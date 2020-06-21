/* handle dropdown clicks on homepage, routing users to desired page */
$(document).on('turbolinks:load', () => {
  handleLinkSelect = e => {
    e.preventDefault;
    const { value, children } = e.target;
    arr = Array.from(children);

    // resolve the url from the option's data attribute
    const url = arr.find(c => c.value == value).dataset.url;

    // reset form for return visits
    document.forms[0].reset()
    if (url) {
      window.location.href = url;
    } else {
      window.location.href = "/queries/" + value;
    }
  }

  rq = document.getElementById('region_query')
  cq = document.getElementById('county_query')

  rq.addEventListener('change', handleLinkSelect);
  cq.addEventListener('change', handleLinkSelect);
});
