/* Muwu navigation */

Muwu.ajax.newDocumentBody = {
  declareRequest: function(targetMetadata) {
    Muwu.activeRequest.documentBody = { xhr: new XMLHttpRequest() };
    Muwu.activeRequest.documentBody.target = targetMetadata;
    Muwu.activeRequest.documentBody.xhr.onreadystatechange = Muwu.ajax.newDocumentBody.onreadystatechange;
    Muwu.activeRequest.documentBody.xhr.responseType = 'document';
  },

  makeRequest: function() {
    Muwu.activeRequest.documentBody.xhr.open('GET', Muwu.activeRequest.documentBody.target.filename);
    Muwu.activeRequest.documentBody.xhr.send();
  },

  onreadystatechange: function() {
    if (Muwu.activeRequest.documentBody.xhr.readyState === XMLHttpRequest.DONE) {
      if (Muwu.activeRequest.documentBody.xhr.status === 200) {
        Muwu.ajax.newDocumentBody.performAction();
      } else {
        Muwu.ajax.newDocumentBody.performAction_failure();
      }
    }
  },

  performAction: function() {
    var newDocumentBody = Muwu.activeRequest.documentBody.xhr.responseXML.body;
    if (newDocumentBody === null) {
      Muwu.ajax.newDocumentBody.performAction_failure();
    } else {
      Muwu.ajax.newDocumentBody.performAction_success(newDocumentBody);
      Muwu.ajax.newDocumentBody.undeclareRequest();
    }
  },

  performAction_failure: function() {
    console.log('XMLHttpRequest failed. Navigating via `window.location`.');
    window.location = Muwu.activeRequest.documentBody.target.href;
  },

  performAction_success: function(newDocumentBody) {
    var targetId = Muwu.activeRequest.documentBody.target.id;
    if (typeof targetId === 'string') {
      document.body.replaceWith(newDocumentBody);
      document.getElementById(targetId).scrollIntoView();
    } else if (typeof targetId === 'undefined') {
      document.body.replaceWith(newDocumentBody);
      window.scrollTo(0,0);
    }
  },

  undeclareRequest: function() {
    Muwu.activeRequest.documentBody = {};
  }
};


Muwu.helper = {
  parse_anchor: function(anchor) {
    var _hrefMetadata = Muwu.helper.parse_href(anchor.getAttribute('href'));
    var filename = _hrefMetadata.filename;
    var href = _hrefMetadata.href;
    var id = _hrefMetadata.id;
    var protocol = anchor.protocol;
    var result = {
      filename: filename,
      href: href,
      id: id,
      protocol: protocol
    };
    return result;
  },

  parse_href: function(href) {
    var _re = /(.*\w+[.]html)?(#{1})?([\w\d-]*)?/;
    var _hrefSplit = href.split(_re);
    var filename = _hrefSplit[1];
    var id = _hrefSplit[3];
    var result = {
      filename: filename,
      href: href,
      id: id
    };
    return result;
  }
};


Muwu.responder.navigateFrom = {
  anchorDocumentLink: function(event) {
    var anchor = event.target;
    var targetMetadata = Muwu.helper.parse_anchor(anchor);
    if (targetMetadata.protocol.match(/^http/)) {
      event.preventDefault();
      if (typeof targetMetadata.filename === 'string') {
        Muwu.responder.navigateTo.url(targetMetadata);
      } else if ((typeof targetMetadata.filename === 'undefined') && (typeof targetMetadata.id ==='string')) {
        Muwu.responder.navigateTo.element(targetMetadata);
      }
    }
  }
};


Muwu.responder.navigateTo = {
  element: function(targetMetadata) {
    if (targetMetadata.id === 'top') {
      Muwu.responder.navigateTo.windowTop();
    } else {
      Muwu.responder.navigateTo.elementById(targetMetadata);
    }
  },

  elementById: function(targetMetadata) {
    document.getElementById(targetMetadata.id).scrollIntoView();;
  },

  url: function(targetMetadata) {
    if (XMLHttpRequest) {
      Muwu.ajax.newDocumentBody.declareRequest(targetMetadata);
      Muwu.ajax.newDocumentBody.makeRequest();
    } else {
      console.log('XMLHttpRequest not available. Navigating via `window.location`.');
      Muwu.responder.navigateTo.windowLocation(targetMetadata);
    }
  },

  windowLocation: function(targetMetadata) {
    window.location = targetMetadata.href;
  },

  windowTop: function() {
    window.scrollTo(0,0);
  }
};


$(document).ready(function() {
  $(document).on('click', '.document_link', function(event) { Muwu.responder.navigateFrom.anchorDocumentLink(event); });
});
