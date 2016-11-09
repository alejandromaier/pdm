// Dropdown
$(document).on('click','.dropdown', e => {
  var $el = $(e.target), $parent = $el.parent()
  e.stopPropagation()
  e.preventDefault()
  $el.attr('aria-expanded','true')
  $parent.addClass('open')
  $(document).one('click', e => {
    $el.attr('aria-expanded','false')
    $parent.removeClass('open')
  })
})

$(document).on('click','.dropdown-menu a, .dropdown-menu button', e => {
  e.stopPropagation()
})
