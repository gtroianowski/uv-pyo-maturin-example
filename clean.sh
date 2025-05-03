#!/usr/bin/env bash

inner_lib_dirs=(
  "rust-library"
)

root_files_to_delete=(
  "uv.lock"
)

root_dirs_to_delete=(
  ".venv"
  "dist"
)

inner_rust_lib_files_to_delete=(
  "Cargo.lock"
  "uv.lock"
)

inner_rust_lib_dirs_to_delete=(
  ".venv"
  "dist"
  "target"
)

for lib in "${inner_lib_dirs[@]}"; do
  if [ ! -d "$lib" ]; then
    echo "No directory $lib. Quitting..."
    exit 1
  fi
  for file in "${inner_rust_lib_files_to_delete[@]}"; do
    full_file_name=$lib/$file
    echo -n "Deleting $full_file_name ... "

    if [ -e "$full_file_name" ]; then
      rm "$full_file_name"
      echo "done."
    else
      echo "not found."
    fi
  done

  for directory in "${inner_rust_lib_dirs_to_delete[@]}"; do
    full_dir_name=$lib/$directory
    echo -n "Deleting $full_dir_name ... "

    if [ -d "$full_dir_name" ]; then
      rm -r "$full_dir_name"
      echo "done."
    else
      echo "not found."
    fi
  done
done


for file in "${root_files_to_delete[@]}"; do
  echo -n "Deleting $file ... "

  if [ -e "$file" ]; then
      rm "$file"
    echo "done."
  else
    echo "not found."
  fi
done

for directory in "${root_dirs_to_delete[@]}"; do
  echo -n "Deleting $directory ... "

  if [ -d "$directory" ]; then
      rm -r "$directory"
    echo "done."
  else
    echo "not found."
  fi
done
