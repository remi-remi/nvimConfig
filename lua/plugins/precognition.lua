return {
   "tris203/precognition.nvim",
   opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" },
      hints = {
         Caret = { text = "^", prio = 2 },
         Dollar = { text = "$", prio = 1 },
         MatchingPair = { text = "%", prio = 5 },
         Zero = { text = "0", prio = 1 },
         w = { text = "w", prio = 10 },
         e = { text = "e", prio = 9 },
         b = { text = "b", prio = 8 },
         W = { text = "W", prio = 7 },
         E = { text = "E", prio = 6 },
         B = { text = "B", prio = 5 },
         t = { text = "t", prio = 4 },
         f = { text = "f", prio = 4 },
         T = { text = "T", prio = 4 },
         F = { text = "F", prio = 4 },
      },
      gutterHints = {
         G = { text = "G", prio = 10 },
         gg = { text = "gg", prio = 9 },
         PrevParagraph = { text = "{", prio = 8 },
         NextParagraph = { text = "}", prio = 8 },
      },
   }
}
