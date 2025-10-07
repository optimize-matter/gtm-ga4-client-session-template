___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "OM - GA4 - Get Client ID \u0026 Session Data",
  "description": "Uses the readAnalyticsStorage API to safely obtain GA4 Client ID or session data (Session ID / Session Number). Session retrieval requires a valid Measurement ID.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "id",
    "label": "Select the type of data you want to retrieve",
    "simpleValueType": true,
    "default": "client_id",
    "radioItems": [
      {
        "value": "client_id",
        "displayValue": "Client ID"
      },
      {
        "value": "session_data",
        "displayValue": "Session Data"
      }
    ],
    "displayName": ""
  },
  {
    "type": "GROUP",
    "name": "session_group",
    "displayName": "Session Configuration",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "measurement_id",
        "displayName": "GA4 Measurement ID",
        "label": "Measurement ID (e.g., G-XXXXXXX)",
        "help": "Required when returning session information. Must start with \u0027G-\u0027.",
        "default": "",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "^G-[A-Z0-9]+$"
            ],
            "errorMessage": "The Measurement ID must start with \u0027G-\u0027 (e.g., G-ABC123DEF4)."
          },
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "session_data_type",
        "displayName": "Session Field",
        "label": "Select which session value to return",
        "simpleValueType": true,
        "default": "session_id",
        "radioItems": [
          {
            "value": "session_id",
            "displayValue": "Session ID"
          },
          {
            "value": "session_number",
            "displayValue": "Session Number"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "id",
        "paramValue": "session_data",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "storage_group",
    "displayName": "Store Data",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "saveinLocalStorage",
        "checkboxText": "Save Data in Local Storage",
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "saveasCookie",
        "checkboxText": "Save Data in a Cookie",
        "simpleValueType": true
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "info",
    "displayName": "About this Template",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "LABEL",
        "name": "credits",
        "displayName": "\u003cstrong\u003e\u003ca href\u003d\"https://www.optimize-matter.com/?utm_source\u003dgtm\u0026utm_medium\u003dtemplates\u0026utm_campaign\u003dtemplate_info\"\u003eMade by Optimizematter 🌐\u003c/a\u003e\u003c/strong\u003e"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const readAnalyticsStorage = require('readAnalyticsStorage');
const localStorage = require('localStorage');
const setCookie = require('setCookie');
const log = require('logToConsole');
const makeString = require('makeString');

const sourceId = data.id;
const saveInLocalStorage = data.saveinLocalStorage;
const saveAsCookie = data.saveasCookie;

// Nom pour le stockage (clé)
const storageKey = "GA_data_";

// Variable pour stocker la valeur finale
let finalValue;

// Options de cookie
const cookieOptions = {
  domain: 'auto',
  path: '/',
  secure: true,
  samesite: 'Lax'
};

// Charger les infos depuis le stockage Analytics
const analyticsData = readAnalyticsStorage();

// Cas client_id
if (sourceId === 'client_id') {
  finalValue = analyticsData.client_id;
  
  if (finalValue) {
  const valueToStore = makeString(finalValue);

  if (saveInLocalStorage) {
    const success = localStorage.setItem(storageKey + "client_id", valueToStore);
  }

  if (saveAsCookie) {
    setCookie(storageKey + "client_id", valueToStore, cookieOptions,false);
  }
}
}

// Cas session_data
if (sourceId === 'session_data') {
  const mId = data.measurement_id;
  const sType = data.session_data_type;
  
  // Recherche d'une session correspondant au Measurement ID
  for (const s of analyticsData.sessions) {
    if (s.measurement_id === mId) {
      if (sType === 'session_id') {
        finalValue = s.session_id;
        if (finalValue) {
  const valueToStore = makeString(finalValue);

  if (saveInLocalStorage) {
    const success = localStorage.setItem(storageKey + "session_id", valueToStore);
  }

  if (saveAsCookie) {
    setCookie(storageKey + "session_id", valueToStore, cookieOptions,false);
  }
}
        break;
      }
      if (sType === 'session_number') {
        finalValue = s.session_number;
        if (finalValue) {
  const valueToStore = makeString(finalValue);

  if (saveInLocalStorage) {
    const success = localStorage.setItem(storageKey + "session_number", valueToStore);

  }

  if (saveAsCookie) {
    setCookie(storageKey + "session_number", valueToStore, cookieOptions,false);
  }
}
        break;
      }
    }
  }
  

}



log('🎯 Valeur finale à retourner:', finalValue);
return finalValue;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_analytics_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_session_number"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_session_id"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_client_id"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_client_id"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_session_id"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "GA_data_session_number"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 03/09/2025, 16:39:46


