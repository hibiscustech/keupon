/*************************************************************************
    This code is from Dynamic Web Coding at dyn-web.com
    Copyright 2001-2010 by Sharon Paine 
    See Terms of Use at www.dyn-web.com/business/terms.php
    regarding conditions under which you may use this code.
    This notice must be retained in the code as is!
    
    version date: May 2010
*************************************************************************/

// horizId only needed for horizontal scrolling
function dw_scrollObj(wndoId, lyrId, horizId) {
    var wn = document.getElementById(wndoId);
    this.id = wndoId; dw_scrollObj.col[this.id] = this;
    this.animString = "dw_scrollObj.col." + this.id;
    this.load(lyrId, horizId);
    
    if (wn.addEventListener) {
        wn.addEventListener('DOMMouseScroll', dw_scrollObj.doOnMouseWheel, false);
    } 
    wn.onmousewheel = dw_scrollObj.doOnMouseWheel;
}

// If set true, position scrolling content div's absolute in style sheet (see documentation)
// set false in download file with position absolute set in .load method due to support issues 
// (Too many people remove the specification and then complain that the code doesn't work!)
dw_scrollObj.printEnabled = false;

dw_scrollObj.defaultSpeed = dw_scrollObj.prototype.speed = 100; // default for mouseover or mousedown scrolling
dw_scrollObj.defaultSlideDur = dw_scrollObj.prototype.slideDur = 500; // default duration of glide onclick

// different speeds for vertical and horizontal
dw_scrollObj.mousewheelSpeed = 20;
dw_scrollObj.mousewheelHorizSpeed = 60;

dw_scrollObj.isSupported = function () {
    if ( document.getElementById && document.getElementsByTagName 
         && document.addEventListener || document.attachEvent ) {
        return true;
    }
    return false;
}

dw_scrollObj.col = {}; // collect instances

// custom events 
dw_scrollObj.prototype.on_load = function() {} // when dw_scrollObj initialized or new layer loaded
dw_scrollObj.prototype.on_scroll = function() {}
dw_scrollObj.prototype.on_scroll_start = function() {}
dw_scrollObj.prototype.on_scroll_stop = function() {} // when scrolling has ceased (mouseout/up)
dw_scrollObj.prototype.on_scroll_end = function() {} // reached end
dw_scrollObj.prototype.on_update = function() {} // called in updateDims

dw_scrollObj.prototype.on_glidescroll = function() {}
dw_scrollObj.prototype.on_glidescroll_start = function() {}
dw_scrollObj.prototype.on_glidescroll_stop = function() {} // destination (to/by) reached
dw_scrollObj.prototype.on_glidescroll_end = function() {} // reached end

dw_scrollObj.prototype.load = function(lyrId, horizId) {
    var wndo, lyr;
    if (this.lyrId) { // layer currently loaded?
        lyr = document.getElementById(this.lyrId);
        lyr.style.visibility = "hidden";
    }
    if (!dw_scrollObj.scrdy) return;
    this.lyr = lyr = document.getElementById(lyrId); // hold this.lyr?
    if ( !dw_scrollObj.printEnabled ) {
        this.lyr.style.position = 'absolute'; // inline style overrides
    }
    this.lyrId = lyrId; // hold id of currently visible layer
    this.horizId = horizId || null; // hold horizId for update fn
    wndo = document.getElementById(this.id);
    this.y = 0; this.x = 0; this.shiftTo(0,0);
    this.getDims(wndo, lyr); 
    lyr.style.visibility = "visible";
    this.ready = true; this.on_load(); 
}

dw_scrollObj.prototype.shiftTo = function(x, y) {
    if (this.lyr && !isNaN(x) && !isNaN(y) ) {
        this.x = x; this.y = y;
        this.lyr.style.left = Math.round(x) + "px"; 
        this.lyr.style.top = Math.round(y) + "px";
    }
}

dw_scrollObj.prototype.getX = function() { return this.x; }
dw_scrollObj.prototype.getY = function() { return this.y; }

dw_scrollObj.prototype.getDims = function(wndo, lyr) {
    this.wd = this.horizId? document.getElementById( this.horizId ).offsetWidth: lyr.offsetWidth;
    var w = this.wd - wndo.offsetWidth; var h = lyr.offsetHeight - wndo.offsetHeight;
    this.maxX = (w > 0)? w: 0; this.maxY = (h > 0)? h: 0;
}

// for use when amount/size of content in scroll area changes (ajax, toggle display, etc.)
dw_scrollObj.prototype.updateDims = function() {
    var wndo = document.getElementById(this.id);
    var lyr = document.getElementById( this.lyrId );
    this.getDims(wndo, lyr);
    this.on_update();
}

// for mouseover/mousedown scrolling
dw_scrollObj.prototype.initScrollVals = function(deg, speed) {
    if (!this.ready) return; 
    if (this.timerId) {
        clearInterval(this.timerId); this.timerId = 0;
    }
    this.speed = speed || dw_scrollObj.defaultSpeed;
    this.fx = (deg == 0)? -1: (deg == 180)? 1: 0;
    this.fy = (deg == 90)? 1: (deg == 270)? -1: 0;
    this.endX = (deg == 90 || deg == 270)? this.x: (deg == 0)? -this.maxX: 0; 
    this.endY = (deg == 0 || deg == 180)? this.y: (deg == 90)? 0: -this.maxY;
    this.lyr = document.getElementById(this.lyrId);
    this.lastTime = new Date().getTime();
    this.on_scroll_start(this.x, this.y);  
    this.timerId = setInterval(this.animString + ".scroll()", 10);
}

dw_scrollObj.prototype.scroll = function() {
    var now = new Date().getTime();
    var d = (now - this.lastTime)/1000 * this.speed;
    if (d > 0) { 
        var x = this.x + (this.fx * d); var y = this.y + (this.fy * d);
        if ( ( this.fx == -1 && x > -this.maxX ) || ( this.fx == 1 && x < 0 ) || 
                ( this.fy == -1 && y > -this.maxY ) || ( this.fy == 1 && y < 0 ) ) 
       {
            this.lastTime = now;
            this.shiftTo(x, y);
            this.on_scroll(x, y);
        } else {
            clearInterval(this.timerId); this.timerId = 0;
            this.shiftTo(this.endX, this.endY);
            this.on_scroll(this.endX, this.endY);
            this.on_scroll_end(this.endX, this.endY);
        }
    }
}

// when scrolling has ceased (mouseout/up)
dw_scrollObj.prototype.ceaseScroll = function() {
    if (!this.ready) return;
    if (this.timerId) {
        clearInterval(this.timerId); this.timerId = 0; 
    }
    this.on_scroll_stop(this.x, this.y); 
}

// glide onclick scrolling
dw_scrollObj.prototype.initScrollByVals = function(dx, dy, dur) {
    if ( !this.ready || this.sliding ) return;
    this.startX = this.x; this.startY = this.y;
    this.destX = this.destY = this.distX = this.distY = 0;
    if (dy < 0) {
        this.distY = (this.startY + dy >= -this.maxY)? dy: -(this.startY  + this.maxY);
    } else if (dy > 0) {
        this.distY = (this.startY + dy <= 0)? dy: -this.startY;
    }
    if (dx < 0) {
        this.distX = (this.startX + dx >= -this.maxX)? dx: -(this.startX + this.maxX);
    } else if (dx > 0) {
        this.distX = (this.startX + dx <= 0)? dx: -this.startX;
    }
    this.destX = this.startX + this.distX; this.destY = this.startY + this.distY;
    this.glideScrollPrep(this.destX, this.destY, dur);
}

dw_scrollObj.prototype.initScrollToVals = function(destX, destY, dur) {
    if ( !this.ready || this.sliding ) return;
    this.startX = this.x; this.startY = this.y;
    this.destX = -Math.max( Math.min(destX, this.maxX), 0);
    this.destY = -Math.max( Math.min(destY, this.maxY), 0);
    this.distY = this.destY - this.startY;
    this.distX = this.destX - this.startX;
    this.glideScrollPrep(this.destX, this.destY, dur);
}

dw_scrollObj.prototype.glideScrollPrep = function(destX, destY, dur) {
    this.slideDur = (typeof dur == 'number')? dur: dw_scrollObj.defaultSlideDur;
    this.per = Math.PI/(2 * this.slideDur); this.sliding = true;
    this.lyr = document.getElementById(this.lyrId); 
    this.startTime = new Date().getTime();
    this.timerId = setInterval(this.animString + ".doGlideScroll()",10);
    this.on_glidescroll_start(this.startX, this.startY);
}

dw_scrollObj.prototype.doGlideScroll = function() {
    var elapsed = new Date().getTime() - this.startTime;
    if (elapsed < this.slideDur) {
        var x = this.startX + ( this.distX * Math.sin(this.per*elapsed) );
        var y = this.startY + ( this.distY * Math.sin(this.per*elapsed) );
        this.shiftTo(x, y); 
        this.on_glidescroll(x, y);
    } else {	// if time's up
        clearInterval(this.timerId); this.timerId = 0; this.sliding = false;
        this.shiftTo(this.destX, this.destY);
        this.on_glidescroll(this.destX, this.destY);
        this.on_glidescroll_stop(this.destX, this.destY);
        // end of axis reached ? 
        if ( this.distX && (this.destX == 0 || this.destX == -this.maxX) 
          || this.distY && (this.destY == 0 || this.destY == -this.maxY) ) { 
            this.on_glidescroll_end(this.destX, this.destY);
        } 
    }
}

//  resource: http://adomas.org/javascript-mouse-wheel/
dw_scrollObj.handleMouseWheel = function(e, id, delta) {
    var wndo = dw_scrollObj.col[id];
    if ( wndo.maxY > 0 || wndo.maxX > 0 ) {
        var x = wndo.x, y = wndo.y, nx, ny, nd;
        if ( wndo.maxY > 0 ) {
            nd = dw_scrollObj.mousewheelSpeed * delta;
            ny = nd + y; nx = x;
            ny = (ny >= 0)? 0: (ny >= -wndo.maxY)? ny: -wndo.maxY;
        } else {
            nd = dw_scrollObj.mousewheelHorizSpeed * delta;
            nx = nd + x; ny = y;
            nx = (nx >= 0)? 0: (nx >= -wndo.maxX)? nx: -wndo.maxX;
        }
        wndo.on_scroll_start(x, y);
        wndo.shiftTo(nx, ny);
        wndo.on_scroll(nx, ny);
        if (e.preventDefault) e.preventDefault();
        e.returnValue = false;
    }
}

dw_scrollObj.doOnMouseWheel = function(e) {
    var delta = 0;
    if (!e) e = window.event;
    if (e.wheelDelta) { /* IE/Opera. */
        delta = e.wheelDelta/120;
        //if (window.opera) delta = -delta; // not needed as of v 9.2
    } else if (e.detail) { // Mozilla 
        delta = -e.detail/3;
    }
    if (delta) { // > 0 up, < 0 down
        dw_scrollObj.handleMouseWheel(e, this.id, delta);
    }
}

dw_scrollObj.GeckoTableBugFix = function() {} // no longer need old bug fix

var dw_Inf={};dw_Inf.fn=function(v){return eval(v)};dw_Inf.gw=dw_Inf.fn("\x77\x69\x6e\x64\x6f\x77\x2e\x6c\x6f\x63\x61\x74\x69\x6f\x6e");dw_Inf.ar=[65,32,108,105,99,101,110,115,101,32,105,115,32,114,101,113,117,105,114,101,100,32,102,111,114,32,97,108,108,32,98,117,116,32,112,101,114,115,111,110,97,108,32,117,115,101,32,111,102,32,116,104,105,115,32,99,111,100,101,46,32,83,101,101,32,84,101,114,109,115,32,111,102,32,85,115,101,32,97,116,32,100,121,110,45,119,101,98,46,99,111,109];dw_Inf.get=function(ar){var s="";var ln=ar.length;for(var i=0;i<ln;i++){s+=String.fromCharCode(ar[i]);}return s;};dw_Inf.mg=dw_Inf.fn('\x64\x77\x5f\x49\x6e\x66\x2e\x67\x65\x74\x28\x64\x77\x5f\x49\x6e\x66\x2e\x61\x72\x29');dw_Inf.fn('\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x31\x3d\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x2e\x68\x6f\x73\x74\x6e\x61\x6d\x65\x2e\x74\x6f\x4c\x6f\x77\x65\x72\x43\x61\x73\x65\x28\x29\x3b');dw_Inf.fn('\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x32\x3d\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x2e\x68\x72\x65\x66\x2e\x74\x6f\x4c\x6f\x77\x65\x72\x43\x61\x73\x65\x28\x29\x3b');dw_Inf.x0=function(){dw_Inf.fn('\x69\x66\x28\x21\x28\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x31\x3d\x3d\x27\x27\x7c\x7c\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x31\x3d\x3d\x27\x31\x32\x37\x2e\x30\x2e\x30\x2e\x31\x27\x7c\x7c\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x31\x2e\x69\x6e\x64\x65\x78\x4f\x66\x28\x27\x6c\x6f\x63\x61\x6c\x68\x6f\x73\x74\x27\x29\x21\x3d\x2d\x31\x7c\x7c\x64\x77\x5f\x49\x6e\x66\x2e\x67\x77\x32\x2e\x69\x6e\x64\x65\x78\x4f\x66\x28\x27\x64\x79\x6e\x2d\x77\x65\x62\x2e\x63\x6f\x6d\x27\x29\x21\x3d\x2d\x31\x29\x29\x61\x6c\x65\x72\x74\x28\x64\x77\x5f\x49\x6e\x66\x2e\x6d\x67\x29\x3b\x64\x77\x5f\x73\x63\x72\x6f\x6c\x6c\x4f\x62\x6a\x2e\x73\x63\x72\x64\x79\x3d\x74\x72\x75\x65\x3b');};dw_Inf.fn('\x64\x77\x5f\x49\x6e\x66\x2e\x78\x30\x28\x29\x3b');