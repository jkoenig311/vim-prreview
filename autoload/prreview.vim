ruby $: << File.expand_path(File.join(Vim.evaluate('g:PRREVIEW_INSTALL_PATH'), '..', 'lib'))
ruby require 'pr_review'

fun! prreview#ReviewPRs()
  setlocal winfixheight
  silent execute 'botright new __PR_list'
  setlocal buftype=nofile
  setlocal bufhidden=delete
  ruby PrReview.print_pull_requests Vim.evaluate('g:pr_review_github_repos'), Vim.evaluate('g:pr_review_query'), Vim.evaluate('g:pr_review_options')
  "remove an extra line at the bottom and move the cursor to the top
  execute 'normal! Gddgg'
  setlocal nomodifiable
  nnoremap <buffer> <silent> o :call prreview#OpenInBrowser()<CR>
  nnoremap <buffer> <silent> q :q<CR>
  nnoremap <buffer> <silent> gx :call prreview#OpenInBrowser()<CR>
  nnoremap <buffer> <silent> <CR> :ruby PrReview.current.pull_request<CR>
  nnoremap <buffer> m :call prreview#MergePr()<CR>
endfun

fun! prreview#OpenInBrowser()
  ruby PrReview.current.browse
endfun

fun! prreview#BrowserCmd(url)
  if has("patch-7.4.567")
    call netrw#BrowseX(a:url,0)
  else
    call netrw#NetrwBrowseX(a:url,0)
  endif
endfun

fun! prreview#MergePr()
  if !exists("g:pr_review_merge_command")
    let g:pr_review_merge_command = "git pull --no-ff --no-edit"
  endif
  ruby PrReview.current.merge
endfun
