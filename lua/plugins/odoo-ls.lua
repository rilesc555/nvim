local odools = require('odools')
local h = os.getenv('HOME')
odools.setup({
    -- mandatory
    odoo_path = h .. "/Dev/odoo/src/odoo/",
    python_path = h .. "/.pyenv/shims/python3",
    server_path = h .. "/.local/bin/odoo_ls_server",

    -- optional
    addons = {h .. "/Dev/odoo/src/odoo/addons", h .. "/Dev/odoo/src/enterprise/", h .. "/Dev/odoo/src/user/"},
    additional_stubs = {h .. "/Dev/odoo/src/typeshed/stubs"},
    root = h .. "/Dev/odoo/src/", -- working directory, odoo_path if empty
    settings = {
        autoRefresh = true,
        autoRefreshDelay = nil,
        diagMissingImportLevel = "none",
    },
})
