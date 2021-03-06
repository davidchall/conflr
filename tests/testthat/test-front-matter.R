# Copyright (C) 2019 LINE Corporation
#
# conflr is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, version 3.
#
# conflr is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See <http://www.gnu.org/licenses/> for more details.

expect_confluence_settings <- function(mock, ...) {
  expected <- list(...)
  cols_to_compare <- names(expected)
  expect_equal(
    mockery::mock_args(mock)[[1]][cols_to_compare],
    expected
  )
}

Rmd_with_all_defaults <-
  'title: "title1"
output:
  conflr::confluence_document:
    space_key: "space1"
    parent_id: 1234
    toc: true
    toc_depth: 4
    supported_syntax_highlighting:
      r: r
      foo: bar
    update: true
    use_original_size: true'

test_that("confluence_settings can be set from front-matter", {

  # case: all settings are specified in the Rmd
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_all_defaults)

  expect_confluence_settings(
    confl_upload_mock,
    title = "title1",
    space_key = "space1",
    parent_id = 1234,
    toc = TRUE,
    toc_depth = 4,
    supported_syntax_highlighting = list(r = "r", foo = "bar"),
    update = TRUE,
    use_original_size = TRUE
  )

  # case: args overwrite settings in the Rmd
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_all_defaults,
    title = "title2", space_key = "space2", parent_id = 9999,
    toc = FALSE, toc_depth = 2, supported_syntax_highlighting = c(two_plus_two = "five"),
    update = FALSE, use_original_size = FALSE
  )

  expect_confluence_settings(
    confl_upload_mock,
    title = "title2",
    space_key = "space2",
    parent_id = 9999,
    toc = FALSE,
    toc_depth = 2,
    supported_syntax_highlighting = c(two_plus_two = "five"),
    update = FALSE,
    use_original_size = FALSE
  )
})

Rmd_with_two_titles <-
  'title: "title1"
output:
  conflr::confluence_document:
    title: "title2"
    space_key: "space1"
    parent_id: 1234
    toc: TRUE
    toc_depth: 4
    supported_syntax_highlighting:
      r: r
      foo: bar
    update: true
    use_original_size: true'

test_that("confluence_settings$title is prior to title", {

  # case: confluence_settings$title is prior to title
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_two_titles)

  expect_confluence_settings(
    confl_upload_mock,
    title = "title2",
    space_key = "space1",
    parent_id = 1234,
    toc = TRUE,
    toc_depth = 4,
    supported_syntax_highlighting = list(r = "r", foo = "bar"),
    update = TRUE,
    use_original_size = TRUE
  )

  # case: args overwrite settings in the Rmd
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_two_titles,
    title = "title3"
  )

  expect_confluence_settings(
    confl_upload_mock,
    title = "title3",
    space_key = "space1",
    parent_id = 1234,
    toc = TRUE,
    toc_depth = 4,
    supported_syntax_highlighting = list(r = "r", foo = "bar"),
    update = TRUE,
    use_original_size = TRUE
  )
})

Rmd_with_some_settings <-
  'title: "title1"
output:
  conflr::confluence_document:
    space_key: "space1"'

test_that("confluence_settings can be specified partially", {

  # case: confluence_settings$title is prior to title
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_some_settings)

  expect_confluence_settings(
    confl_upload_mock,
    title = "title1",
    space_key = "space1"
  )
})

test_that("supported_syntax_highlighting can be set via option", {

  # case: confluence_settings$title is prior to title
  confl_upload_mock <- mockery::mock(NULL)

  withr::with_options(
    list(conflr_supported_syntax_highlighting = "r"),
    do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_with_some_settings)
  )

  expect_confluence_settings(
    confl_upload_mock,
    supported_syntax_highlighting = "r"
  )
})


Rmd_without_space_key <- 'title: "title1"'

test_that("confluence_settings raise an error when any of mandatory parameters are missing", {

  # case: when space_key is not in the front-matter but in the arguments, it works
  confl_upload_mock <- mockery::mock(NULL)
  do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_without_space_key, space_key = "space2")
  expect_confluence_settings(
    confl_upload_mock,
    title = "title1",
    space_key = "space2"
  )
})

Rmd_deprecated <-
  'title: "title1"
confluence_settings:
  space_key: "space1"
  parent_id: 1234
  toc: true
  toc_depth: 4
  supported_syntax_highlighting:
    r: r
    foo: bar
  update: true
  use_original_size: true'

test_that("confluence_settings are accepted for backward-compatibility", {

  # case: all settings are specified in the Rmd
  confl_upload_mock <- mockery::mock(NULL)
  expect_warning(
    do_confl_create_post_from_Rmd(confl_upload_mock, Rmd_deprecated)
  )

  expect_confluence_settings(
    confl_upload_mock,
    title = "title1",
    space_key = "space1",
    parent_id = 1234,
    toc = TRUE,
    toc_depth = 4,
    supported_syntax_highlighting = list(r = "r", foo = "bar"),
    update = TRUE,
    use_original_size = TRUE
  )
})
