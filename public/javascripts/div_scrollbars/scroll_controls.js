/*************************************************************************
    This code is from Dynamic Web Coding at dyn-web.com
    Copyright 2008-10 by Sharon Paine 
    See Terms of Use at www.dyn-web.com/business/terms.php
    regarding conditions under which you may use this code.
    This notice must be retained in the code as is!

    unobtrusive event handling, etc. 
    for use with dw_scroll.js
    version date: May 2010
*************************************************************************/

var dw_Util; if (!dw_Util) dw_Util = {};

// media=screen unless optional second argument passed as false
dw_Util.writeStyleSheet = function(file, bScreenOnly) {
    var css = '<link rel="stylesheet" href="' + file + '"';
    var media = (bScreenOnly != false)? '" media="screen"': '';
    document.write(css + media + ' />');
}

// slower, may flash unstyled ?
dw_Util.addLinkCSS = function(file, bScreenOnly) {
    if ( !document.createElement ) return;
    var el = document.createElement("link");
    el.setAttribute("rel", "stylesheet");
    el.setAttribute("type", "text/css");
    if (bScreenOnly != false) {
        el.setAttribute("media", "screen");
    }
    el.setAttribute("href", file);
    document.getElementsByTagName('head')[0].appendChild(el);
}

// for backwards compatibility
dw_writeStyleSheet = dw_Util.writeStyleSheet;
dw_addLinkCSS = dw_Util.addLinkCSS;

// returns true of oNode is contained by oCont (container)
dw_Util.contained = function (oNode, oCont) {
    if (!oNode) return null; // in case alt-tab away while hovering (prevent error)
    while ( (oNode = oNode.parentNode) ) if ( oNode == oCont ) return true;
    return false;
}

// treacherous cross-browser territory
// Get position of el within layer (oCont)
dw_Util.getLayerOffsets = function (el, oCont) {
    var left = 0, top = 0;
    if ( dw_Util.contained(el, oCont) ) {
        do {
            left += el.offsetLeft;
            top += el.offsetTop;
        } while ( ( (el = el.offsetParent) != oCont) );
    }
    return { x:left, y:top };
}

// replaces dw_scrollObj.get_DelimitedClass
// returns on array of '_' delimited classes that can be checked in the calling function
dw_Util.get_DelimitedClassList = function(cls) {
    var ar = [], ctr = 0;
    if ( cls.indexOf('_') != -1 ) {
        var whitespace = /\s+/;
        if ( !whitespace.test(cls) ) {
            ar[0] = cls;
        } else {
            var classes = cls.split(whitespace); 
            for (var i = 0; classes[i]; i++) { 
                if ( classes[i].indexOf('_') != -1 ) {
                    ar[ctr++] = classes[i]; // no empty elements
                }
            }
        }
    }
    return ar;
}

dw_Util.inArray = function(val, ar) {
    for (var i=0; ar[i]; i++) {
        if ( ar[i] == val ) {
            return true;
        }
    }
    return false;
}
/////////////////////////////////////////////////////////////////////

// Example class names: load_wn_lyr1, load_wn_lyr2_t2
dw_scrollObj.prototype.setUpLoadLinks = function(controlsId) {
    var wndoId = this.id; var el = document.getElementById(controlsId); 
    var links = el.getElementsByTagName('a'); // not checking for el
    var list, cls, clsStart, clsEnd, pt, parts, lyrId, horizId;
    clsStart = 'load_' + wndoId + '_'; // className for load starts with this
    for (var i=0; links[i]; i++) {
        list = dw_Util.get_DelimitedClassList( links[i].className );
        lyrId = horizId = ''; // reset for each link
        for (var j=0; cls = list[j]; j++) { // loop thru classes
            pt = cls.indexOf(clsStart);
            if ( pt != -1 ) { // has 'load_' + wndoId 
                clsEnd = cls.slice( clsStart.length );
                // rest of string might be lyrId, or maybe lyrId_horizId
                if ( document.getElementById(clsEnd) ) {
                    lyrId = clsEnd, horizId = null;
                } else if ( clsEnd.indexOf('_') != -1 ) {
                    parts = clsEnd.split('_');
                    if ( document.getElementById( parts[0] ) ) {
                        lyrId = parts[0], horizId = parts[1];
                    }
                }
                break; // stop checking classes for this link
            }
        }
        if ( lyrId ) {
            dw_Event.add( links[i], 'click', function (wndoId, lyrId, horizId) {
                return function (e) {
                    dw_scrollObj.col[wndoId].load(lyrId, horizId);
                    if (e && e.preventDefault) e.preventDefault();
                    return false;
                }
            }(wndoId, lyrId, horizId) ); // see Crockford js good parts pg 39
        }
    }
}

dw_scrollObj.prototype.setUpScrollControls = function(controlsId, autoHide, axis) {
    var wndoId = this.id; var el = document.getElementById(controlsId); 
    if ( autoHide && axis == 'v' || axis == 'h' ) {
        dw_scrollObj.handleControlVis(controlsId, wndoId, axis);
        dw_Scrollbar_Co.addEvent( this, 'on_load', function() { dw_scrollObj.handleControlVis(controlsId, wndoId, axis); } );
        dw_Scrollbar_Co.addEvent( this, 'on_update', function() { dw_scrollObj.handleControlVis(controlsId, wndoId, axis); } );
    }
    var links = el.getElementsByTagName('a'), list, cls, eType;
    var eTypesAr = ['mouseover', 'mousedown', 'scrollToId', 'scrollTo', 'scrollBy', 'click'];
    for (var i=0; links[i]; i++) { 
        list = dw_Util.get_DelimitedClassList( links[i].className );
        for (var j=0; cls = list[j]; j++) { // loop thru classes
            eType = cls.slice(0, cls.indexOf('_') );
            if ( dw_Util.inArray(eType, eTypesAr) ) {
                switch ( eType ) {
                    case 'mouseover' :
                    case 'mousedown' :
                        dw_scrollObj.handleMouseOverDownLinks(links[i], wndoId, cls);
                        break;
                    case 'scrollToId': 
                        dw_scrollObj.handleScrollToId(links[i], wndoId, cls);
                        break;
                    case 'scrollTo' :
                    case 'scrollBy':
                    case 'click': 
                        dw_scrollObj.handleClick(links[i], wndoId, cls) ;
                        break;
                }
                break; // stop checking classes for this link
            }
        }
    }
}

dw_scrollObj.handleMouseOverDownLinks = function (linkEl, wndoId, cls) {
    var parts = cls.split('_'); var eType = parts[0];
    var re = /^(mouseover|mousedown)_(up|down|left|right)(_[\d]+)?$/;
                
    if ( re.test(cls) ) { 
        var dir = parts[1];  var speed = parts[2] || null; 
        var deg = (dir == 'up')? 90: (dir == 'down')? 270: (dir == 'left')? 180: 0;
            
        if ( eType == 'mouseover') {
            dw_Event.add(linkEl, 'mouseover', function (e) { dw_scrollObj.col[wndoId].initScrollVals(deg, speed); } );
            dw_Event.add(linkEl, 'mouseout', function (e) { dw_scrollObj.col[wndoId].ceaseScroll(); } );
            dw_Event.add( linkEl, 'mousedown', function (e) { dw_scrollObj.col[wndoId].speed *= 3; } );
            dw_Event.add( linkEl, 'mouseup', function (e) { 
                dw_scrollObj.col[wndoId].speed = dw_scrollObj.prototype.speed; } ); 
        } else { // mousedown
            dw_Event.add(linkEl, 'mousedown', function (e) { 
                dw_scrollObj.col[wndoId].initScrollVals(deg, speed); 
                e = dw_Event.DOMit(e); e.preventDefault(); 
                } );
                
            dw_Event.add(linkEl, 'dragstart', function (e) { 
                e = dw_Event.DOMit(e); e.preventDefault(); //e.target.style.cursor = 'default';
            } );
                
            dw_Event.add(linkEl, 'mouseup', function (e) { dw_scrollObj.col[wndoId].ceaseScroll(); } );
            // will stop scrolling onmouseup (would otherwise continue)
            dw_Event.add(linkEl, 'mouseout', function (e) { dw_scrollObj.col[wndoId].ceaseScroll(); } );
        }
        dw_Event.add( linkEl, 'click', function(e) { if (e && e.preventDefault) e.preventDefault(); return false; } );
    }
}

// now supports use of underscore in id of element to scroll to, 
// if not using the lyrId or dur portions of the class
// scrollToId_smile, scrollToId_smile_100, scrollToId_smile_lyr1_100    
dw_scrollObj.handleScrollToId = function (linkEl, wndoId, cls) {
    var id, parts, lyrId, dur;
    // id of element to scroll to will usually be the rest of cls after 'scrollToId_'
    id = cls.slice(11); //'scrollToId_' length
    if ( !document.getElementById(id) ) { // when other 'args' used in cls (lyrId, dur)
        parts = cls.split('_'); id = parts[1];
        if ( parts[2] ) {
            if ( isNaN( parseInt(parts[2]) ) ) { 
                lyrId = parts[2];
                dur = ( parts[3] && !isNaN( parseInt(parts[3]) ) )? parseInt(parts[3]): null;
            } else {
                dur = parseInt( parts[2] );
            }
        }
    }
    dw_Event.add( linkEl, 'click', function (e) {
            dw_scrollObj.scrollToId(wndoId, id, lyrId, dur);
            if (e && e.preventDefault) e.preventDefault();
            return false;
        } );
}

dw_scrollObj.scrollToId = function(wndoId, id, lyrId, dur) {
    var wndo = dw_scrollObj.col[wndoId], wndoEl = document.getElementById(wndoId), lyr, pos;
    var el = document.getElementById(id);
    if (!el || !(dw_Util.contained(el, wndoEl) ) ) { return; } 
    if (lyrId) {
        lyr = document.getElementById(lyrId); // layer whose id passed
        if ( lyr && dw_Util.contained(lyr, wndoEl) && wndo.lyrId != lyrId ) {
            wndo.load(lyrId);
        }
    }
    lyr = document.getElementById(wndo.lyrId); // layer loaded
    pos = dw_Util.getLayerOffsets(el, lyr);
    wndo.initScrollToVals(pos.x, pos.y, dur);
}

dw_scrollObj.handleClick = function (linkEl, wndoId, cls) {
    var wndo = dw_scrollObj.col[wndoId];
    var parts = cls.split('_'); var eType = parts[0]; 
    var dur_re = /^([\d]+)$/; var fn, re, x, y, dur;
    
    switch (eType) {
        case 'scrollTo' :
            fn = 'scrollTo';  re = /^(null|end|[\d]+)$/;
            x = re.test( parts[1] )? parts[1]: '';
            y = re.test( parts[2] )? parts[2]: '';
            dur = ( parts[3] && dur_re.test(parts[3]) )? parts[3]: null;
            break;
        case 'scrollBy': // scrollBy_m30_m40, scrollBy_null_m100, scrollBy_100_null
            fn = 'scrollBy';  re = /^(([m]?[\d]+)|null)$/;
            x = re.test( parts[1] )? parts[1]: '';
            y = re.test( parts[2] )? parts[2]: '';
            
            // negate numbers (m not - but vice versa) 
            if ( !isNaN( parseInt(x) ) ) {
                x = -parseInt(x);
            } else if ( typeof x == 'string' ) {
                x = x.indexOf('m') !=-1 ? x.replace('m', ''): x;
            }
            if ( !isNaN( parseInt(y) ) ) {
                y = -parseInt(y);
            } else if ( typeof y == 'string' ) {
                y = y.indexOf('m') !=-1 ? y.replace('m', ''): y;
            }
            
            dur = ( parts[3] && dur_re.test(parts[3]) )? parts[3]: null;
            break;
        
        case 'click': 
            var o = dw_scrollObj.getClickParts(cls);
            fn = o.fn; x = o.x; y = o.y; dur = o.dur;
            break;
    }
    
    if ( x !== '' && y !== '' ) {
        dur = !isNaN( parseInt(dur) )? parseInt(dur): null;
        if (fn == 'scrollBy') {
            dw_Event.add( linkEl, 'click', function (e) {
                    dw_scrollObj.scrollBy(wndoId, x, y, dur);
                    if (e && e.preventDefault) e.preventDefault();
                    return false;
                } );
        } else if (fn == 'scrollTo') {
            dw_Event.add( linkEl, 'click', function (e) {
                    dw_scrollObj.scrollTo(wndoId, x, y, dur);
                    if (e && e.preventDefault) e.preventDefault();
                    return false;
                } );
        }
    }
}


//////////////////////////////////////////////////////////////////////////
//  from html_att_ev.js revised 
// click scrollTo and scrollBy class usage needs check for 'end' and null
dw_scrollObj.scrollBy = function(wndoId, x, y, dur) {
    if ( dw_scrollObj.col[wndoId] ) {
        var wndo = dw_scrollObj.col[wndoId];
        x = (x === null)? -wndo.x: parseInt(x);
        y = (y === null)? -wndo.y: parseInt(y);
        wndo.initScrollByVals(x, y, dur);
    }
}

dw_scrollObj.scrollTo = function(wndoId, x, y, dur) {
    if ( dw_scrollObj.col[wndoId] ) {
        var wndo = dw_scrollObj.col[wndoId];
        x = (x === 'end')? wndo.maxX: x;
        y = (y === 'end')? wndo.maxY: y;
        x = (x === null)? -wndo.x: parseInt(x);
        y = (y === null)? -wndo.y: parseInt(y);
        wndo.initScrollToVals(x, y, dur);
    }
}
//
//////////////////////////////////////////////////////////////////////////

// get info from className (e.g., click_down_by_100)
dw_scrollObj.getClickParts = function(cls) {
    var parts = cls.split('_');
    var re = /^(up|down|left|right)$/;
    var dir, fn = '', dur, ar, val, x = '', y = '';
    
    if ( parts.length >= 4 ) {
        ar = parts[1].match(re);
        dir = ar? ar[1]: null;
            
        re = /^(to|by)$/; 
        ar = parts[2].match(re);
        if (ar) {
            fn = (ar[0] == 'to')? 'scrollTo': 'scrollBy';
        } 
    
        val = parts[3]; // value on x or y axis
        re = /^([\d]+)$/;
        dur = ( parts[4] && re.test(parts[4]) )? parts[4]: null;
    
        switch (fn) {
            case 'scrollBy' :
                if ( !re.test( val ) ) {
                    x = ''; y = ''; break;
                }
                switch (dir) { // 0 for unspecified axis 
                    case 'up' : x = 0; y = val; break;
                    case 'down' : x = 0; y = -val; break;
                    case 'left' : x = val; y = 0; break;
                    case 'right' : x = -val; y = 0;
                 }
                break;
            case 'scrollTo' :
                re = /^(end|[\d]+)$/;
                if ( !re.test( val ) ) {
                    x = ''; y = ''; break;
                }
                switch (dir) { // null for unspecified axis 
                    case 'up' : x = null; y = val; break;
                    case 'down' : x = null; y = (val == 'end')? val: -val; break;
                    case 'left' : x = val; y = null; break;
                    case 'right' : x = (val == 'end')? val: -val; y = null;
                 } 
                break;
         }
    }
    return { fn: fn, x: x, y: y, dur: dur }
}

dw_scrollObj.handleControlVis = function(controlsId, wndoId, axis) {
    var wndo = dw_scrollObj.col[wndoId];
    var el = document.getElementById(controlsId);
    if ( ( axis == 'v' && wndo.maxY > 0 ) || ( axis == 'h' && wndo.maxX > 0 ) ) {
        el.style.visibility = 'visible';
    } else {
        el.style.visibility = 'hidden';
    }
}