use std::{
    borrow::Cow,
    convert::Infallible,
    env::{args_os, var_os},
    ffi::{OsStr, OsString},
    hint::cold_path,
    iter::empty,
    os::unix::{ffi::OsStrExt as _, process::CommandExt as _},
    process::{Command, ExitCode},
};

const STABLE_PATH: &'static str = env!("STABLE_PATH");

fn main() -> ExitCode {
    let mut args = args_os();

    let channel = if args.next().is_some()
        && let Some(channel) = args.next()
    {
        channel
    } else {
        cold_path();

        let Err(()) = fallback_to_shell(STABLE_PATH);

        return ExitCode::FAILURE;
    };

    let rust_path = match channel.as_bytes() {
        b"s" | b"stable" => STABLE_PATH,
        b"b" | b"beta" => env!("BETA_PATH"),
        b"n" | b"nightly" => env!("NIGHTLY_PATH"),
        _ => {
            cold_path();

            eprintln!(
                "Unrecognized channel {channel:?}!\nValid options:\ts\tstable\tb\tbeta\tn\tnightly"
            );

            return ExitCode::FAILURE;
        }
    };

    let Err(()) = if let Some(program) = args.next() {
        exec(program, args, rust_path)
    } else {
        fallback_to_shell(rust_path)
    };

    cold_path();

    ExitCode::FAILURE
}

fn fallback_to_shell(rust_path: &str) -> Result<Infallible, ()> {
    if let Some(shell) = var_os("SHELL") {
        eprintln!("Starting a shell. Selected shell: {}", shell.display());

        exec(shell, empty::<&OsStr>(), rust_path)
    } else {
        cold_path();

        eprintln!(r#"Shell fallback failed because the "SHELL" environment variable is not set!"#);

        Err(())
    }
}

fn exec<Args>(program: OsString, args: Args, rust_path: &str) -> Result<Infallible, ()>
where
    Args: IntoIterator<Item: AsRef<OsStr>>,
{
    let error = Command::new(&program)
        .args(args)
        .env("PATH", construct_path(rust_path))
        .exec();

    cold_path();

    eprintln!(
        "Failed to run the program! Binary: {}\n{error}",
        program.display()
    );

    Err(())
}

fn construct_path(rust_path: &str) -> Cow<'_, OsStr> {
    let rust_path = OsStr::new(rust_path);

    if let Some(old_path) = var_os("PATH")
        && !old_path.is_empty()
    {
        let separator = OsStr::new(":");

        let mut new_path = OsString::new();

        new_path.reserve_exact(rust_path.len() + separator.len() + old_path.len());

        new_path.push(rust_path);

        new_path.push(separator);

        new_path.push(old_path);

        Cow::Owned(new_path)
    } else {
        cold_path();

        Cow::Borrowed(rust_path)
    }
}
