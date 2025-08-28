'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon.png": "3fb13c7c68b603de2039bc22f7ad5edb",
"assets/assets/data/tests.json": "ea7ba1b5abe83a4742a744adcc89b6f3",
"assets/assets/data/tests/do80/test/51.png": "de2b54eb4b4ba5ab8abad575559b6da5",
"assets/assets/data/tests/do80/test/79.png": "85c6b3127980a4b93fd32fc4e9b3463c",
"assets/assets/data/tests/do80/test/67.png": "0e74823830556e945edee7f007c9bd41",
"assets/assets/data/tests/do80/test/21.png": "3c4e01d4a9ac9e3ef14938c8f26ebc4d",
"assets/assets/data/tests/do80/test/47.png": "6a4abd4b3404bd89bab1c48bdd38a201",
"assets/assets/data/tests/do80/test/41.png": "f36e8a047319455178ce8eecea279d6f",
"assets/assets/data/tests/do80/test/40.png": "dcb763345502cf45427a86476f455c30",
"assets/assets/data/tests/do80/test/46.png": "5823326bd489fb3b5bef03c3e7022712",
"assets/assets/data/tests/do80/test/14.png": "904b31e91e209b693055aa7dbefd7150",
"assets/assets/data/tests/do80/test/50.png": "92a66e17a46451352bcc194c54cdbc9b",
"assets/assets/data/tests/do80/test/5.png": "b095ee07b9b3d5b4e9bdae3987577e68",
"assets/assets/data/tests/do80/test/17.png": "2034da64f34374944431d3730093eb86",
"assets/assets/data/tests/do80/test/3.png": "9948fc5e12b0c0f5ea5a1d6490410ca4",
"assets/assets/data/tests/do80/test/15.png": "509cd6ae8ed569b7d38be09cfe2088d5",
"assets/assets/data/tests/do80/test/10.png": "96e90b00914b751d173159b1db6ad3f0",
"assets/assets/data/tests/do80/test/62.png": "71fa6d50ea4d86a46681a75c2dcc9178",
"assets/assets/data/tests/do80/test/76.png": "17e57f4d82d45c28c986ef8a8c72593c",
"assets/assets/data/tests/do80/test/34.png": "1f4652aa54972243a01c29aaa3c45634",
"assets/assets/data/tests/do80/test/57.png": "e644cd248a85c3f7f6c66d1a5fd9cc9e",
"assets/assets/data/tests/do80/test/65.png": "c1048e990bc28ba4e377dfe9447fb7f6",
"assets/assets/data/tests/do80/test/9.png": "7195fa1a0393fd8bcffa94c193c3b708",
"assets/assets/data/tests/do80/test/64.png": "f7be619009c266e7e0b7ca4dfb466a6a",
"assets/assets/data/tests/do80/test/80.png": "b568740a0a742128365902bc5d718718",
"assets/assets/data/tests/do80/test/52.png": "eca4b0b1a03dbfb797fd39f630c01719",
"assets/assets/data/tests/do80/test/54.png": "393c1a13273d164f3370cd7188db4c88",
"assets/assets/data/tests/do80/test/69.png": "fcb523bf7f8243bf57ffedba04521ff6",
"assets/assets/data/tests/do80/test/49.png": "e5a77f2a2e07a9e4453ea18b5cc2de3e",
"assets/assets/data/tests/do80/test/13.png": "e760373d054a3f4a4a1ee46f444dd470",
"assets/assets/data/tests/do80/test/18.png": "37c7c50c9379965416042a7f08211441",
"assets/assets/data/tests/do80/test/59.png": "3b629f9f0244b94315a59e9bd44844fe",
"assets/assets/data/tests/do80/test/33.png": "8302133cec84d5aedc34c2af1c6ef97b",
"assets/assets/data/tests/do80/test/53.png": "54ea299039b02edf4d2e819b2a6edbfd",
"assets/assets/data/tests/do80/test/73.png": "01d5dacc43a4c948da2fa620a8f45c14",
"assets/assets/data/tests/do80/test/43.png": "e1af176e511d61ab1a0927c8dad41148",
"assets/assets/data/tests/do80/test/81.png": "075e55eaffa7c7f8ade9f689f7ac6747",
"assets/assets/data/tests/do80/test/29.png": "a3e59eefdbe3dec9cadf8be8af46a019",
"assets/assets/data/tests/do80/test/56.png": "fad74fa3c88744e1e829b3b2cdd1ae37",
"assets/assets/data/tests/do80/test/71.png": "7aeb0cb112d3557780f1fbf8052e92a3",
"assets/assets/data/tests/do80/test/61.png": "0ec8912d44619072ca22e1cc4ff6a9ac",
"assets/assets/data/tests/do80/test/26.png": "e9477f9d89c253ff844ad2048db525a9",
"assets/assets/data/tests/do80/test/58.png": "371829652952a1d9d8bbf34394032ed2",
"assets/assets/data/tests/do80/test/37.png": "f102f90bf04a82b1f15c8699c010aec5",
"assets/assets/data/tests/do80/test/25.png": "81d6b97e1c07168f25fae1085012255e",
"assets/assets/data/tests/do80/test/66.png": "1cb0fd3551830a2799229123b47aa98e",
"assets/assets/data/tests/do80/test/23.png": "60b9a1b8ed8049fc95ee47e7db665d30",
"assets/assets/data/tests/do80/test/31.png": "13e2a290a0c7bc6b002271617e20892d",
"assets/assets/data/tests/do80/test/22.png": "13811d6d0f849635d6e773fb8f1f5712",
"assets/assets/data/tests/do80/test/32.png": "22cfd95fd7ecedfd12e7423fcf287503",
"assets/assets/data/tests/do80/test/27.png": "d8a2a12fae55908621f23b0dd0d3544b",
"assets/assets/data/tests/do80/test/4.png": "8448bac6bdd29c2e2b8921af3007f1d1",
"assets/assets/data/tests/do80/test/24.png": "491fd9411e0e89d41dc855cda74726fb",
"assets/assets/data/tests/do80/test/68.png": "669f0298bb9a71754b9570da307654bc",
"assets/assets/data/tests/do80/test/19.png": "03a5d878c78e6492c1b4a76aafa5dfc5",
"assets/assets/data/tests/do80/test/45.png": "5fe94c82ba43e5b94f4a4ade1a43d45d",
"assets/assets/data/tests/do80/test/44.png": "6cceaae19305cca61c3c24f32dab5232",
"assets/assets/data/tests/do80/test/75.png": "fbd37ecd1871c55861611ff75ba4012c",
"assets/assets/data/tests/do80/test/20.png": "dd1aa4e4b75f3edaef566eefa15ba0c9",
"assets/assets/data/tests/do80/test/7.png": "b618e155445cd3b7fa07debb278f3482",
"assets/assets/data/tests/do80/test/35.png": "992f2b4a0ca6ba17e40b22421e354fd9",
"assets/assets/data/tests/do80/test/12.png": "2bb433a06ea3b4f1f203e2953ec5ed35",
"assets/assets/data/tests/do80/test/60.png": "9c66bc89246a342243f1b091cacfab13",
"assets/assets/data/tests/do80/test/36.png": "ef8ce0705c65391489a2d526e73ae1f5",
"assets/assets/data/tests/do80/test/2.png": "49a25fec61b888eb980fc69da8018cec",
"assets/assets/data/tests/do80/test/70.png": "eafa68c8ba4e3dc82c443cd0f24d9710",
"assets/assets/data/tests/do80/test/8.png": "45f311702f702db6f2e9874f5c3e448e",
"assets/assets/data/tests/do80/test/72.png": "14fbaa8d589a932cfdf85f970b038e77",
"assets/assets/data/tests/do80/test/74.png": "dbd569ecd4351b356119ff5c62dda293",
"assets/assets/data/tests/do80/test/16.png": "984331c90dec25c39be5380681257233",
"assets/assets/data/tests/do80/test/55.png": "82bef481075f809bc27f4f16c2f5bc99",
"assets/assets/data/tests/do80/test/39.png": "e5be0f85e1e30a697f75c1b9c1c7887e",
"assets/assets/data/tests/do80/test/6.png": "ab53773e47889d4551b69e9176e92a11",
"assets/assets/data/tests/do80/test/48.png": "0c810dbb1326b2198175fbd8ecaf2f5e",
"assets/assets/data/tests/do80/test/77.png": "8f809960ed1025e8eab0816e586e7c85",
"assets/assets/data/tests/do80/test/63.png": "405b62c0587efcd5f2b5b21c1b93536a",
"assets/assets/data/tests/do80/test/28.png": "3484e173e5e6470accfc4466a4256287",
"assets/assets/data/tests/do80/test/42.png": "4935dc9e8f1703b125a0a6847520bd12",
"assets/assets/data/tests/do80/test/30.png": "4703984e95921c045e714a64ec64dc18",
"assets/assets/data/tests/do80/test/11.png": "04eba8c616da4778d9f4d4d90e4f0da2",
"assets/assets/data/tests/do80/test/78.png": "b6f8057e2e0c7e16287f544145c7f52b",
"assets/assets/data/tests/do80/test/38.png": "f3c8287e5a4a633de609893ebfc16a3d",
"assets/assets/data/tests/boston_naming_test/test/51.png": "88add5a5a5debc84ab6db9603031c334",
"assets/assets/data/tests/boston_naming_test/test/21.png": "2ae081213b0afb908779cf9b1468d81a",
"assets/assets/data/tests/boston_naming_test/test/47.png": "348d20d25008972d615c2231c54def12",
"assets/assets/data/tests/boston_naming_test/test/41.png": "846cb7c129dad5a175580d3854d53578",
"assets/assets/data/tests/boston_naming_test/test/40.png": "2ebcd238bb6f2f886249572d86f8bcc4",
"assets/assets/data/tests/boston_naming_test/test/46.png": "b37cd10acd4a75f46a19c00481c7a6a6",
"assets/assets/data/tests/boston_naming_test/test/14.png": "132a1b61b9bf3d97fce805440989221c",
"assets/assets/data/tests/boston_naming_test/test/50.png": "3fca42a927671662b16284de45816e1f",
"assets/assets/data/tests/boston_naming_test/test/5.png": "ff9f443987603c3f4889deddbada2f99",
"assets/assets/data/tests/boston_naming_test/test/17.png": "80efbdb72a7d8c9c8580b57f7985b272",
"assets/assets/data/tests/boston_naming_test/test/3.png": "680ec7401c08b1bb0dda5af0e92d7157",
"assets/assets/data/tests/boston_naming_test/test/15.png": "63f7d7066036d1f915c052a9db4cccf7",
"assets/assets/data/tests/boston_naming_test/test/10.png": "e5dc8a351b405b0cdd55c392c20b9ef7",
"assets/assets/data/tests/boston_naming_test/test/34.png": "da9de5d9285c593f36c8816bd67b32c9",
"assets/assets/data/tests/boston_naming_test/test/57.png": "25d869c3e47459f89a8e4c146d76ad9c",
"assets/assets/data/tests/boston_naming_test/test/9.png": "e9d3364fa4de4b9d64746145d9fbb29a",
"assets/assets/data/tests/boston_naming_test/test/52.png": "9b7acce0b38dfa65ea5591efca1a5fff",
"assets/assets/data/tests/boston_naming_test/test/54.png": "d39e147dbc7f69b45d0102bf46c469cf",
"assets/assets/data/tests/boston_naming_test/test/49.png": "afc6bac85f36b59b8017b9289f28d6ff",
"assets/assets/data/tests/boston_naming_test/test/13.png": "0907f954d242c40344224676807ee4b7",
"assets/assets/data/tests/boston_naming_test/test/18.png": "a6e05e8e2a81429a0b75f6b362eabda8",
"assets/assets/data/tests/boston_naming_test/test/59.png": "2506a4d8bf36ca1e2db64440268c19f6",
"assets/assets/data/tests/boston_naming_test/test/33.png": "3d8f492df8e422c99d2a807689b1bcb7",
"assets/assets/data/tests/boston_naming_test/test/53.png": "543b5a2d9f6606cfb4226096873a78b5",
"assets/assets/data/tests/boston_naming_test/test/43.png": "f7e9f1ab5020bafabde8fa3dc4b35212",
"assets/assets/data/tests/boston_naming_test/test/29.png": "ac9cbf4443fb0cb8fd6f49643992f9dd",
"assets/assets/data/tests/boston_naming_test/test/56.png": "57c2f1317c3ef1f7b2fd9c3d705bc121",
"assets/assets/data/tests/boston_naming_test/test/26.png": "7d69b3286c2b4410920f8b99e54116a8",
"assets/assets/data/tests/boston_naming_test/test/58.png": "fc58072f359a3c8016a3a1fafe267c11",
"assets/assets/data/tests/boston_naming_test/test/37.png": "5281731c0304116aa3b5c54a4ed3f56b",
"assets/assets/data/tests/boston_naming_test/test/25.png": "019e022cf560ad2428168f965e4eadfd",
"assets/assets/data/tests/boston_naming_test/test/23.png": "ebc667e199422d7d6a5ede4f96b48b50",
"assets/assets/data/tests/boston_naming_test/test/31.png": "b8d827292bad8dde65716afbbe965312",
"assets/assets/data/tests/boston_naming_test/test/22.png": "d5abb4eccae4b03365c298222cd317a5",
"assets/assets/data/tests/boston_naming_test/test/32.png": "04f968f7da0606f77a57a5212f4b28dd",
"assets/assets/data/tests/boston_naming_test/test/27.png": "fe8ee13fc6c7738d732db2cb8e0382f0",
"assets/assets/data/tests/boston_naming_test/test/4.png": "1217abb3135e7c26ed5a8c2ddd2cef9c",
"assets/assets/data/tests/boston_naming_test/test/24.png": "12a133336bb16260eb3ea0664ac4689b",
"assets/assets/data/tests/boston_naming_test/test/19.png": "d9ca1e8c1d906c34b8278c80132906b7",
"assets/assets/data/tests/boston_naming_test/test/45.png": "fdea20e9a54c0d172dfe459a75079872",
"assets/assets/data/tests/boston_naming_test/test/44.png": "88ddc76199a15f62cd8188b161460b3a",
"assets/assets/data/tests/boston_naming_test/test/20.png": "1c82ccd3e77e0ccb293fd6aa80352bb6",
"assets/assets/data/tests/boston_naming_test/test/7.png": "645e25fa3d9aed07809e622daa235a30",
"assets/assets/data/tests/boston_naming_test/test/35.png": "3a26304a6d855988807d3cb0df619022",
"assets/assets/data/tests/boston_naming_test/test/12.png": "8d341e1c09d50123bda89610c19c60ec",
"assets/assets/data/tests/boston_naming_test/test/60.png": "19401eda6b2c07810e7728b9cb622767",
"assets/assets/data/tests/boston_naming_test/test/36.png": "7c60cb7f653bd28316d5bc0af288c8a4",
"assets/assets/data/tests/boston_naming_test/test/2.png": "5aa10948a17256f71d9f56784e8f0874",
"assets/assets/data/tests/boston_naming_test/test/8.png": "67958c1dcf4be182084b6d40846d31e7",
"assets/assets/data/tests/boston_naming_test/test/16.png": "725cdd907272df70ddde49d8ccbd3b54",
"assets/assets/data/tests/boston_naming_test/test/55.png": "482101d85d40044fd69aebb512ca28b6",
"assets/assets/data/tests/boston_naming_test/test/39.png": "22fb7c4f1cc5074c82d59ed4ef89b960",
"assets/assets/data/tests/boston_naming_test/test/1.png": "9d789c53028ca4d085880d2427ae5f9d",
"assets/assets/data/tests/boston_naming_test/test/6.png": "f010db4b06980c6b0b65e6408ef00a95",
"assets/assets/data/tests/boston_naming_test/test/48.png": "eeb5ec2ade573b29e21d9cf01d1dbbf1",
"assets/assets/data/tests/boston_naming_test/test/28.png": "f732e4e19b6c16684213fee5906a3316",
"assets/assets/data/tests/boston_naming_test/test/42.png": "727a4f7c0fb1b0ac7c1b8184594eb6ca",
"assets/assets/data/tests/boston_naming_test/test/30.png": "9ffb9e98713b10fd527d8d4d83050944",
"assets/assets/data/tests/boston_naming_test/test/11.png": "12de22f395c1cc7eef38b5faae4d9dec",
"assets/assets/data/tests/boston_naming_test/test/38.png": "f90ea76b04e5b15f795bdf8c85b11ae9",
"assets/assets/data/tests/boston_naming_test/complementary/3.png": "b7ae28795b9f12c845f6102a9f873cfd",
"assets/assets/data/tests/boston_naming_test/complementary/4.png": "86ed557588b2d122ce419f282cf94e2a",
"assets/assets/data/tests/boston_naming_test/complementary/2.png": "56fde211c6d66f212c3a3a59028d0cfc",
"assets/assets/data/tests/boston_naming_test/complementary/1.png": "81f151a1070fe9a581c7d73e84ef3af9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "bc2cfea9c25ded3f8dbb52ec71fd1820",
"assets/AssetManifest.json": "38fd9614840a36f8d4bf3eedcbd4f89c",
"assets/fonts/MaterialIcons-Regular.otf": "f6fcc4bb2600aecdc2462d6266c621ae",
"assets/NOTICES": "49444d72275b5a840695cc6faceaf4de",
"assets/AssetManifest.bin": "b9142893c7aa94b471759a97b3db5046",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"icons/Icon-512.png": "0d958506fe51d09c03586f65bf1cf85f",
"icons/icon-192.png": "c6eac15b8fce404fa2a021a7067d1f6c",
"index.html": "c95227a3bd444b51174ffea011ab7f6f",
"/": "c95227a3bd444b51174ffea011ab7f6f",
"manifest.json": "186ab3857099d86da68a122b7ddb8fd3",
"main.dart.js": "fb745b1042cd18225785ca7424c63623",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"version.json": "03d4807c7d43c4b84ed56320a3018453",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"flutter_bootstrap.js": "e45b5c548e4ddfe49686c76da0d41d71"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
