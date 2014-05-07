// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

function uniqueStarrersAndReposters(starrers, reposters) {
  var userIdMapper = function (user) { return user.id; };
  var ret = [];
  var i, starrerIds, reposterIds;
  for (i = 0; i < starrers.length; i++) {
    starrerIds = ret.map(userIdMapper);
    if (-1 === $.inArray(starrers[i].id, starrerIds)) {
      ret.push(starrers[i]);
    }
  }
  for (i = 0; i < reposters.length; i++) {
    reposterIds = ret.map(userIdMapper);
    if (-1 === $.inArray(reposters[i].id, reposterIds)) {
      ret.push(reposters[i]);
    }
  }
  return ret;
}

function linkUsers(users) {
  return users.map(function (user) {
    return '<a href="/u/' + user.username + '">' + user.username + '</a>';
  }).join(", ");
}

function pluralize(word, count) {
  if (word === "people") {
    return (count === 1) ? "person" : "people";
  }
}

function avatarsForPost(starrers, reposters) {
  return uniqueStarrersAndReposters(starrers, reposters).map(function (user) {
    return "<a href='/u/'" + user.username + "'><img class='small-avatar' src='" + user.avatar_image.url + "' /></a>";
  }).join();
}

function initLoading(username) {
  function getJsonSuccess(data) {
    if (data.min_id !== null) {
      $.getJSON('/data.json?user=' + username + '&before_id=' + data.min_id, getJsonSuccess);
    } else {
      $("#loading_indicator").fadeOut("slow", function () { $("#loading_indicator").remove(); });
    }

    var posts = data.posts;
    var i;
    for (i = 0; i < data.posts.length; i++) {
      myViewModel.posts.push(posts[i]);
    }
  }

  $.getJSON('/data.json?user=' + username, getJsonSuccess);
}

function prettyTimestamp(createdAt) {
  return Date.parse(createdAt).toString("MMM dS yyyy, h:mm tt");
}


function ViewModel() {
  this.posts = ko.observableArray([]);
}
var myViewModel = new ViewModel();

$(document).ready(function () {
  ko.applyBindings(myViewModel);
});
