return {
  {
    "numToStr/Comment.nvim",
    opts = function(_, opts)
      local pre_hook = require("Comment.ft").calculate

      opts.pre_hook = function(ctx)
        local file = vim.api.nvim_buf_get_name(0)

        if file:match("%.ini$") then
          vim.bo.commentstring = "# %s"
        end

        return pre_hook(ctx)
      end

      return opts
    end,
  },
}
