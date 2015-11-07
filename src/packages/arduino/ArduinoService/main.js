/*!
 * OS.js - JavaScript Operating System
 *
 * Copyright (c) 2011-2015, Anders Evenrud <andersevenrud@gmail.com>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met: 
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution. 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author  Anders Evenrud <andersevenrud@gmail.com>
 * @licence Simplified BSD License
 */
(function(Service, Window, Utils, API, VFS, GUI) {
  'use strict';

  /////////////////////////////////////////////////////////////////////////////
  // SERVICE
  /////////////////////////////////////////////////////////////////////////////

  function ArduinoService(args, metadata) {
    Service.apply(this, ['ArduinoService', args, metadata]);
  }

  ArduinoService.prototype = Object.create(Service.prototype);
  ArduinoService.constructor = Service;

  ArduinoService.prototype.destroy = function() {
    var wm = OSjs.Core.getWindowManager();
    if ( wm ) {
      wm.destroyNotificationIcon('_ArduinoServiceNotification');
    }
    return Service.prototype.destroy.apply(this, arguments);
  };

  ArduinoService.prototype.init = function(settings, metadata, onInited) {
    Service.prototype.init.apply(this, arguments);

    var wm = OSjs.Core.getWindowManager();

    function showContextMenu(ev) {
      OSjs.API.createMenu([{
        title: 'Open Settings',
        onClick: function() {
          API.launch('ApplicationSettings', {
            category: 'arduino'
          });
        }
      }], ev);
    }

    wm.createNotificationIcon('_ArduinoServiceNotification', {
      onContextMenu: showContextMenu,
      onClick: showContextMenu,
      onInited: function(el) {
        if ( el ) {
          var img = document.createElement('img');
          img.title = img.alt = 'Open Settings';
          img.src = API.getIcon('arduino.png');
          el.appendChild(img);
        }
      }
    });

    onInited();
  };

  ArduinoService.prototype._onMessage = function(obj, msg, args) {
    if ( msg === 'attention' ) {
      // args.foo
    }
  };

  /////////////////////////////////////////////////////////////////////////////
  // EXPORTS
  /////////////////////////////////////////////////////////////////////////////

  OSjs.Applications = OSjs.Applications || {};
  OSjs.Applications.ArduinoService = OSjs.Applications.ArduinoService || {};
  OSjs.Applications.ArduinoService.Class = ArduinoService;

})(OSjs.Core.Service, OSjs.Core.Window, OSjs.Utils, OSjs.API, OSjs.VFS, OSjs.GUI);
