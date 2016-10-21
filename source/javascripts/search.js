(function() {
  function displaySearchResults(results, store) {
    var searchResults = document.getElementById('search-results');

    if (results.length) { // Are there any results?
      var appendString = '';

      for (var i = 0; i < results.length; i++) {  // Iterate over the results
        var item = store[results[i].ref];
        appendString += '<div class="list-item-entry"><div class="hotel-item style-3 bg-white"><div class="table-view">';
        appendString += '<div class="radius-top cell-view">'+item.image+'</div>';
        appendString += '<div class="title hotel-middle clearfix cell-view"><h4><b>' + item.title + '</b></h4></div>';
        appendString += '<div class="title hotel-right clearfix cell-view">';
        appendString += '<div class="hotel-person color-dark-2">' + item.category + '</div><br/>';
        appendString += '<a class="c-button b-40 bg-blue hv-blue-o grid-hidden" href="'+item.url+'" style="display:block;">Más detalles</a>';
        appendString += "</div></div></div></div>";
      }

      searchResults.innerHTML = appendString;
    } else {
      searchResults.innerHTML = '<li>No se encontraron resultados...</li>';
    }
  }

  function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split('&');

    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split('=');

      if (pair[0] === variable) {
        return decodeURIComponent(pair[1].replace(/\+/g, '%20'));
      }
    }
  }

  var searchTerm = getQueryVariable('query');

  if (searchTerm) {
    document.getElementById('search-box').setAttribute("value", searchTerm);

    // Initalize lunr with the fields it will be searching on. I've given title
    // a boost of 10 to indicate matches on this field are more important.
    var idx = lunr(function () {
      this.field('id');
      this.field('title', { boost: 10 });
      this.field('pais', { boost: 20 });
      //this.field('category');
    });

    // Add the data to lunr
    for (var key in window.store) {
      idx.add({
        'id': key,
        'title': window.store[key].title,
        'category': window.store[key].category,
        'pais': window.store[key].pais
      });

      var results = idx.search(searchTerm); // Get lunr to perform a search
      displaySearchResults(results, window.store);
    }


  }

})();
