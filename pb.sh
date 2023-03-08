#!/bin/sh

command -p curl --version >/dev/null 2>&1 || \
  { printf '"curl" is required but not found. Aborting.\n' >&2; exit 1; }

# Commands.
compress() { tar -C "$(dirname "$1")" -czf - "$(basename "$1")"; }
encrypt() { gpg --armor --symmetric --output -; }
upload() { curl --silent -form expires=336 --form file=@- https://0x0.st; }

# Handle options.
while getopts 'eh' opt
do
  case $opt in
    e) command -p gpg --version >/dev/null 2>&1 || \
         { printf '"gpg" is required but not found. Aborting.\n' >&2; exit 1; }
       encryption=true ;;
    h) help=true ;;
    *) ;;
  esac
done
shift $((OPTIND-1))

# Help menu.
if test -n "$help"; then
  cat <<EOF
${0##*/} is a command line interface to post file(s)
for sharing at <https://0x0.st>. Files up to 512MB
can be uploaded and are deleted after 14 days.

  Usage:

    ${0##*/} [options] <file|directory>
    ... | ${0##*/} [options]

  Options:

    -e      Encrypt <file|directory> before uploading.
    -h      Show this help menu.

  Examples:

    # upload file /tmp/test.md
    ${0##*/} /tmp/test.md

    # upload stdout/stderr
    cat /tmp/test.md | ${0##*/}

    # encrypt file before uploading
    ${0##*/} -e /tmp/test.md
EOF
  exit
fi

# Handle file upload.
file="$1"

if tty >/dev/null 2>&1; then
  test -e "$file" || \
    { printf '%s: No such file or directory.\n' "$file" >&2; exit 1; }

  # Directory.
  if test -d "$file"; then
    command -p tar --version >/dev/null 2>&1 || \
      { printf '"tar" is required but not found. Aborting.\n' >&2; exit 1; }

    if test -n "$encryption"; then
      compress "$file" | encrypt | upload
    else
      compress "$file" | upload
    fi

  # File.
  else
    if test -n "$encryption"; then
      encrypt < "$file" | upload
    else
      upload < "$file"
    fi
  fi

# Piped input.
else
  if test -n "$encryption"; then
    encrypt | upload
  else
    upload
  fi
fi
