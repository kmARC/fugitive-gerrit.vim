" Location:     autoload/gerrit/fugitive.vim
" Maintainer:   Mark Korondi <korondi.mark@gmail.com>

" see: fugitive_browse_handlers
function! gerrit#fugitive#url(opts, ...) abort
  if a:0 || type(a:opts) != type({})
    return ''
  endif

  let domains = get(g:, 'fugitive_gerrit_domains', [])
  let domains = map(domains, { _, domain ->  split(domain, '://')[-1] })

  let domain_pattern = join(domains, '\|')

  if a:opts.commit =~# '^\d\=$'
    let commit = a:opts.repo.rev_parse('HEAD')
  else
    let commit = a:opts.commit
  endif

  try
    let [domain, repo] = matchlist(a:opts.remote,'^.*\(' . escape(domain_pattern, '.') . '\)[^/]*/\zs\(.*\)$')[1:2]
  catch /.*/
    " None of the domains could be found
    return ''
  endtry

  if domain == '' || repo == ''
    return ''
  endif

  let url  = 'https://' . domain . '/plugins/gitiles/' . repo . '/+/' . commit . '/' . a:opts.path 

  if a:opts.line1 > 0
    let url .= '#' . a:opts.line1
  endif

  return url
endfunction

