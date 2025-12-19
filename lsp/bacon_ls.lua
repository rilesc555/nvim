return {
  cmd = { 'bacon-ls' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml' },
  single_file_support = true,
  init_options = {
    -- Using native Cargo backend (default in 0.23.0+)
    -- No need for bacon to be running
    updateOnSave = true,
    updateOnSaveWaitMillis = 500,
  },
}
