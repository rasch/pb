# pb

Upload files to [0x0.st](https://0x0.st), then display the url. The file is
deleted after 14 days. There is a file size limit of 512MB.

## Usage

Upload a file or directory. Directories are compressed using tar and gzip. Pass
the `-e` option to encrypt the file using GnuPG before uploading.

```txt
pb <file|directory>
pb -e <file|directory>
```

The `pb` script also accepts stdin.

```txt
... | pb
... | pb -e
```

## Install

```sh
pnpm add --global @rasch/pb
```

<details><summary>npm</summary><p>

```sh
npm install --global @rasch/pb
```

</p></details>
<details><summary>yarn</summary><p>

```sh
yarn global add @rasch/pb
```

</p></details>
