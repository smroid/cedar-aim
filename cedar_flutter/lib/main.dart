// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/client_main.dart';

import 'package:cedar_flutter/catalog_browser.dart';
import 'package:cedar_flutter/draw_catalog.dart';

void main() {
  clientMain(
      /*drawCatalogEntries=*/ drawCatalogEntries,
      /*showCatalogBrowser=*/ showCatalogBrowser,
      /*objectInfoDialog=*/ null,
      /*wifiAccessPointDialog=*/ null,
      /*gotoRaDecDialog=*/ null,
      /*updaterInfo=*/ null,
      /*updateServiceAvailable=*/ false);
}
