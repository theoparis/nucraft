export def bundle_jar [
  --output: string,
  input_directory: string,
] {
  jar cvf $output -C $input_directory .
}
