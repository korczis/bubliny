top = document.querySelector 'header'
updateTopClass = (scrollTop) ->
  top.className = if scrollTop > 0 then "" else "top"

updateScroll = (scrollTop) ->
  updateTopClass scrollTop

updateScroll document.body.scrollTop
window.addEventListener "scroll" -> updateScroll (window.document.documentElement.scrollTop || window.document.body.scrollTop)

data = d3.tsv.parse ig.data.posts

partiesAssoc = {}

for datum in data
  datum.id = datum.page_id + "_" + datum.post_id
  if not partiesAssoc[datum.party]
    partiesAssoc[datum.party] = {name: datum.party, posts: []}
  partiesAssoc[datum.party].posts.push datum
parties = for party, data of partiesAssoc => data
container = d3.select ig.containers.base
defaults =
  left: partiesAssoc["TOP09"]
  right: partiesAssoc["Úsvit"]

for let part in <[left right]>
  feed = container.append \div
    ..attr \class "feed " + part
  selector = feed.append \ul
    ..attr \class \selector
  content = feed.append \div
    ..attr \class \content
  selectParty = (party) ->
    selectorItems.classed \active -> it is party
    content.selectAll \.fb-post .remove!
    content.selectAll \.fb-post .data party.posts.slice 0, 10 .enter!append \div
      ..attr \data-href -> "https://www.facebook.com/#{it.page_id}/posts/#{it.post_id}"
      ..attr \class \fb-post
    FB?XFBML.parse!

  selectorItems = selector.selectAll \li .data parties .enter!append \li
    ..append \a
      ..html (.name)
      ..attr \href \#
      ..on \click ->
        d3.event.preventDefault!
        selectParty it
  <~ setTimeout _, 1000
  selectParty defaults[part]
