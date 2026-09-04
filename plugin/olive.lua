vim.api.nvim_create_user_command("HelloWorld", require("olive").say_hello, {})
