# Copyright (C) 2019 LINE Corporation
#
# conflr is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, version 3.
#
# conflr is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See <http://www.gnu.org/licenses/> for more details.

test_that("TOC is added when set via argument", {
  tmp <- tempfile(fileext = ".Rmd")
  on.exit(unlink(tmp))

  writeLines(
    "---
title: title1
output:
  conflr::confluence_document:
    toc: false
    space_key: space1
---

# h1
## h2
", tmp
  )

  mock <- mockery::mock(NULL)
  with_mock(
    "conflr::confl_list_attachments" = function(...) list(results = list()),
    "conflr::confl_update_page" = mock,
    "conflr::confl_get_current_user" = function(...) list(username = "user"),
    "conflr:::try_get_existing_page_id" = function(...) 1,
    "conflr:::try_get_personal_space_key" = should_not_be_called,
    {
      confl_create_post_from_Rmd(tmp, interactive = FALSE, update = TRUE, toc = TRUE)
    }
  )

  expect_equal(
    mockery::mock_args(mock)[[1]]$body,
    '<p>
  <ac:structured-macro ac:name="toc">
    <ac:parameter ac:name="maxLevel">7</ac:parameter>
  </ac:structured-macro>
</p>
<h1>h1</h1>
<h2>h2</h2>'
  )
})

test_that("TOC is added when set via front-matter", {
  tmp <- tempfile(fileext = ".Rmd")
  on.exit(unlink(tmp))

  writeLines(
    "---
title: title1
output:
  conflr::confluence_document:
    space_key: space1
    toc: true
    toc_depth: 3
---

# h1
## h2
", tmp
  )

  mock <- mockery::mock(NULL, cycle = TRUE)
  with_mock(
    "conflr::confl_list_attachments" = function(...) list(results = list()),
    "conflr::confl_update_page" = mock,
    "conflr::confl_get_current_user" = function(...) list(username = "user"),
    "conflr:::try_get_existing_page_id" = function(...) 1,
    "conflr:::try_get_personal_space_key" = should_not_be_called,
    {
      confl_create_post_from_Rmd(tmp, interactive = FALSE, update = TRUE)
      confl_create_post_from_Rmd(tmp, interactive = FALSE, update = TRUE, toc = FALSE)
    }
  )

  expect_equal(
    mockery::mock_args(mock)[[1]]$body,
    '<p>
  <ac:structured-macro ac:name="toc">
    <ac:parameter ac:name="maxLevel">3</ac:parameter>
  </ac:structured-macro>
</p>
<h1>h1</h1>
<h2>h2</h2>'
  )

  expect_equal(
    mockery::mock_args(mock)[[2]]$body,
    "<h1>h1</h1>\n<h2>h2</h2>"
  )
})
