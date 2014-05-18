def strip_path_and_extension(file)
  File.dirname(file).split('/')[-1] + "/" + File.basename(file, ".*")
end