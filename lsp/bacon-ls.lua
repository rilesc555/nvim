return {
  cmd = { 'bacon-ls' },
  filetypes = { 'rust' },
  root_markers = { '.bacon-locations', 'Cargo.toml' },
  settings = {
    single_file_support = true,
    init_options = {
      createBaconPreferencesFile = true,
      updateOnSave = true,
      updateOnSaveWaitMillis = 500,
    },
  },
}