export default {
  "app.title": "Melis",
  "app.wallet": "wallet",
  "locale": "English",
  "locales": {
    "en": "English",
    "it": "Italiano"
  },
  "errors": {
    "description": "This field",
    "inclusion": "{{description}} is not included in the list",
    "exclusion": "{{description}} is reserved",
    "invalid": "{{description}} is invalid",
    "confirmation": "{{description}} doesn't match {{on}}",
    "accepted": "{{description}} must be accepted",
    "empty": "{{description}} can't be empty",
    "blank": "{{description}} can't be blank",
    "present": "{{description}} must be blank",
    "collection": "{{description}} must be a collection",
    "singular": "{{description}} can't be a collection",
    "tooLong": "{{description}} is too long (maximum is {{max}} characters)",
    "tooShort": "{{description}} is too short (minimum is {{min}} characters)",
    "before": "{{description}} must be before {{before}}",
    "after": "{{description}} must be after {{after}}",
    "wrongDateFormat": "{{description}} must be in the format of {{format}}",
    "wrongLength": "{{description}} is the wrong length (should be {{is}} characters)",
    "notANumber": "{{description}} must be a number",
    "notAnInteger": "{{description}} must be an integer",
    "greaterThan": "{{description}} must be greater than {{gt}}",
    "greaterThanOrEqualTo": "{{description}} must be greater than or equal to {{gte}}",
    "equalTo": "{{description}} must be equal to {{is}}",
    "lessThan": "{{description}} must be less than {{lt}}",
    "lessThanOrEqualTo": "{{description}} must be less than or equal to {{lte}}",
    "otherThan": "{{description}} must be other than {{value}}",
    "odd": "{{description}} must be odd",
    "even": "{{description}} must be even",
    "positive": "{{description}} must be positive",
    "date": "{{description}} must be a valid date",
    "email": "{{description}} must be a valid email address",
    "phone": "{{description}} must be a valid phone number",
    "url": "{{description}} must be a valid url"
  },
  "validations": {
    "insfunds": "Insufficient Funds.",
    "notbitcoin": "Not a coin address",
    "not-coin": "Not a valid coin address",
    "not-pubid": "Not a Melis public id",
    "duplicate-alias": "This alias is aready taken",
    "not-mnemonic": "Not a valid mnemonic"
  },
  "generic": {
    "loginfailed": "Login Failed.",
    "disconnected": "disconnected reconnecting...",
    "not-set": "[ not set ]",
    "ok": "Ok",
    "cancel": "Cancel",
    "alert": {
      "title": "Warning",
      "caption": "The operation you are performing can have consequences that require your attention."
    }
  },
  "actions": {
    "receive": "Receive",
    "send": "Send"
  },
  "label-picker": {
    "ph": "choose classification labels"
  },
  "coins": {
    "unit": {
      "nocoin": "No Coin",
      "allcoins": "All Coins",
      "btc": "Bitcoin",
      "bch": "Bitcoin Cash",
      "abc": "Bitoin ABC",
      "ltc": "Litecoin",
      "grs": "Groestlcoin",
      "bsv": "Satoshi Vision",
      "doge": "Doge",
      "tbtc": "Testnet Bitcoin",
      "tbch": "Testnet Bitcoin Cash",
      "tabc": "Testnet Bitcoin ABC",
      "tltc": "Testnet Litecoin",
      "tgrs": "Testnet Groestlcoin",
      "tbsv": "Testnet Satoshi Vision",
      "tdog": "Testnet Doge",
      "rbtc": "Regtest Bitcoin",
      "rbch": "Regtest Bitcoin Cash",
      "rabc": "Regtest Bitcoin ABC",
      "rltc": "Regtest Litecoin",
      "rgrs": "Regtest Groestlcoin",
      "rbsv": "Regtest Satoshi Vision",
      "rdog": "Regtest Doge"
    }
  },
  "acct": {
    "types": {
      "plain": {
        "name": "Single User no Server",
        "description": "Simple single user account without server protection",
        "explain": "This is the simplest account type with a single signature (yours). The server can't limit your expenses or guarantee Instant Transactions."
      },
      "twooftwo": {
        "name": "Single user with Server",
        "description": "2of2 Multisig with Mandatory Server Signature",
        "explain": "This is the default account type: the funds can be moved only with both user and server signatures. The server is able to limit expenses and guarantee Instant Transactions."
      },
      "multisrv": {
        "name": "Multiuser with Server",
        "description": "Multiuser account with Mandatory Server Signature",
        "explain": "This multisig account requires the server signature and a configurabile number of other cosigners. The server is able limit expenses and guarantee Instant Transactions."
      },
      "multi": {
        "name": "Multisignature [+ Server]",
        "description": "Multisignature with Optional Server",
        "explain": "This multisig account expects a non-mandatory server signature ed un numero configurabile di cofirmatari. Il server non può limitare le spese e garantire transazioni instantanee."
      },
      "multisimp": {
        "name": "Multisignature without server",
        "description": "Multiuser account without Server Signature",
        "explain": "This multisig account requires a configurable number of cosigners to move funds. The server can't limit your expenses or guarantee Instant Transactions."
      },
      "cosigner": {
        "name": "Cosigner",
        "description": "Cosigner in a Multisignature Account",
        "explain": "Use this to join a multisignature account."
      },
      "unknown": {
        "name": "Unknown Account Name",
        "description": "Unknown Account Description",
        "explain": "Unknown Account Explaination"
      }
    },
    "simple": {
      "plain": {
        "name": "Without Server",
        "description": "Without Server",
        "explain": "An account without a server has no costs but doesn't offer additional security features."
      },
      "twooftwo": {
        "name": "With Server",
        "description": "With Server",
        "explain": "An account with server signature offers the best security but can incur into small storage fees."
      }
    }
  },
  "aa": {
    "modal": {
      "title": "Authorization",
      "pin": {
        "title": "Pin is required",
        "caption": "For security reasons your pin is required to authorize this operation."
      },
      "tfa": {
        "title": "TFA",
        "caption": "For security reasons your 2fa is required to authorize this operation."
      },
      "token": {
        "title": "We need your invite code",
        "caption": "Melis is still preview technology. For this reason we are still picking a few people to test our products. If you received an invite code please enter it here. If not you can request one at our website.",
        "label": "Invite code",
        "ph": "Type here the invite code you received.",
        "error": "There was an error checking your invite code. This is temporary so please try it again in a moment.",
        "invalid": "I am sorry your invite code is not valid."
      }
    },
    "error": {
      "busy": "Cannot perform authorization now already a challenge in progress.",
      "token-req": "Invite Token was required but did not complete.",
      "tfa-req": "Two Factors Authentication was required but not completed.",
      "tfa-pin-req": "Two Factors Authentication or Pin challenge was required but not completed.",
      "invalid-tfa-token": "Invalid TFA token"
    }
  },
  "ab": {
    "empty": {
      "title": "Address book is empty",
      "caption": "Use the addressbook to keep track of other Melis users or simple addresses"
    },
    "nomatch": {
      "title": "No matches for your search",
      "caption": "Please simplify your search to allow more results."
    },
    "types": {
      "cm": "Another Melis User",
      "address": "Generic Coin Address"
    },
    "table": {
      "pubid": "Public Identity:",
      "alias": "Alias:",
      "name": "Name:",
      "profile": "Profile:"
    },
    "form": {
      "type": {
        "label": "Type of contact",
        "coin": "Coin"
      },
      "name": {
        "label": "Name",
        "ph": "Enter a name to identify this contact..."
      },
      "alias": {
        "label": "Alias or Public Identity",
        "ph": "search an alias or a public identity"
      },
      "address": {
        "label": "Address",
        "ph": "Enter an address for this contact..."
      },
      "labels": {
        "label": "Labels"
      },
      "t": {
        "melis": "Another Melis User",
        "addr": "Generic Address"
      }
    },
    "state": {
      "no-contacts": "Your address book is empty",
      "no-matches": "No contacts match your search",
      "populate": "You can populate it using the button down below"
    },
    "links": {
      "manage": "Address Book Management"
    }
  },
  "account": {
    "secure": "secure",
    "lite": "lite",
    "defaults": {
      "name": "My first account"
    },
    "actions": {
      "Logout": "logout"
    },
    "selector": {
      "joined": "{{count}}/{{total}} Cosigners joined",
      "joined-s": "{{count}}/{{total}} joined"
    },
    "mgmt": {
      "title": "All the accounts",
      "caption": "All the accounts associated to this wallet.",
      "secure": {
        "title": "Secure accounts",
        "caption": "A secure account is visible only on the <b>primary</b> device."
      }
    },
    "maint": {
      "title": "Maintenance operations",
      "caption": "Advanced operations to perform on your account",
      "lite": {
        "title": "Lite account",
        "caption": "This is a lite account, some changes and options are not available for lite accounts, or might be only available from your lite client"
      },
      "hide": {
        "title": "Hide this account",
        "caption": "Hidden accounts disappear from your menu on <b>this</b> device but keep operating normally. You can re-enable them at any time."
      },
      "secure": {
        "title": "Make Secure",
        "caption": "A secure account is only shown on the <b>primary</b> device.",
        "already": "This account is currently secure.",
        "warn": "This is <b>not</b> the primary device if you mark this account secure it will disappear from here.",
        "prompt": {
          "title": "Setting as secure",
          "caption": "This account will disappear from your secondary devices."
        },
        "npprompt": {
          "title": "Not primary device.",
          "caption": "<b>Setting this account as secure will make it disappear from this device</b>. You will need the primary device to reactivate it."
        }
      },
      "danger": {
        "title": "Danger Zone",
        "caption": "This will enable dangerous operations"
      },
      "delete": {
        "hasbalance": "This account <b>has a positive balance</b> therefore can not be removed.",
        "title": "Remove account",
        "caption": "This will delete your account. Can't be undone.",
        "btn": "Delete account",
        "w": {
          "title": "Remove account",
          "caption": "Removing an account will rendere it unaccessible. <b>Are you sure you want to remove it?</b>"
        }
      },
      "xpub": {
        "title": "Export account T/XPUB",
        "caption": "",
        "clip": "copy to clipboard"
      }
    },
    "cosigners": {
      "you": "You",
      "collect": {
        "title": "Define cosigners name",
        "caption": "Please enter a name of at least 4 letters to identify your cosigners and select if their signature is mandatory or not"
      },
      "form": {
        "name": {
          "label": "Name",
          "ph": "Name for this cosigner..."
        },
        "mname": {
          "label": "Your Name",
          "ph": "How your cosigners will see you"
        },
        "mmandatory": "Is your signature mandatory?",
        "fees": "Fees for this account will be <b>{{fees}}x</b> compared to a single signature."
      },
      "readonly": "in this scheme some co-signers are read-only "
    },
    "multi": {
      "i-master": {
        "title": "This is a multisignature account",
        "caption": "Send your co-signers the join code next to their names and wait for them to join."
      },
      "i-co": {
        "title": "This is a multisignature account",
        "caption": "The account will be active once all the cosigners have joined."
      },
      "status": {
        "cosigners": "Cosigners",
        "title": "Multisignature Account",
        "caption": "This text should tell you the status of the account",
        "server-sig": "Server Signature",
        "server-mand": "Server is Mandatory",
        "master": "master",
        "mandatory": "mandatory",
        "not-joined": "Not Joined Yet",
        "joined": "joined",
        "clip": "Copy join code to clipboard",
        "incomplete": "Waiting for co-signers to join",
        "delete": "Delete this account",
        "lite": "Lite Account"
      },
      "join": {
        "code": {
          "label": "Join Code",
          "ph": "Enter the code to join"
        },
        "notfound": "The provided join code was not found.",
        "default-name": "New Multisignature Account"
      }
    },
    "unavailable": {
      "title": "Account is not available",
      "caption": "The selected account is not available"
    },
    "utils": {
      "title": "Utilities",
      "caption": "Various useful things about your Melis account",
      "profile": {
        "title": "Public profile URL",
        "caption": "You can use this URL to direct people tyo your public Melis profile"
      },
      "donate": {
        "title": "Donations",
        "caption": "You can direct from your own pages to a donation page on the Melis website where your visitors can leave a donation for you.",
        "explain": "This is the code to embed the link:"
      },
      "payto": {
        "title": "Public payment URL",
        "caption": "Receive payments or donations from any other Melis user or anyone with a cryptocurrency wallet"
      }
    },
    "wizard": {
      "t-coin": {
        "title": "Coin",
        "caption": "Coin",
        "desc": "Pick the coin"
      },
      "t-single": {
        "title": "Personal Account",
        "caption": "<b>The account is just for yourself.</b> You will be able to make every kind of operations on the funds contained in the account."
      },
      "t-multi": {
        "title": "Multi Signature Account",
        "caption": "<b>An advanced account shared with other users.</b> Shared accounts require a predefined number of signatures from your co-signers before important operations can be authorized. <i>You will define who and how many your co-signers are in a moment.</i>"
      },
      "server": {
        "title": "Does your account need server side protection?",
        "caption": "Server side protection ensures you can set limits on how you or your co-signers can spend the funds. <b>Server side protection makes the account secure but for technical reasons it may incur in small fees.</sb>"
      },
      "t-with-server": {
        "title": "The account requires a server signature",
        "caption": "<b>The server signature can enforce spending policies.</b> This also enables instant transactions with selected parties. Choose this if unsure."
      },
      "t-no-server": {
        "title": "Account without server signature",
        "caption": "<b>The security of the account is completely up to you</b> or the users sharing the account and the signature scheme you select."
      },
      "cosigners": {
        "requiredSigsTitle": "Required signatures",
        "requiredSigsCaption": "The minimum required number of signatures required to authorize a spending transaction.",
        "cosignerInfo": "Cosigner details",
        "masterInfo": "Master (you)"
      },
      "t-type": {
        "caption": "Account Type",
        "desc": "Single or Multisignature"
      },
      "t-server": {
        "caption": "Server",
        "desc": "Server side protection"
      },
      "t-name": {
        "caption": "Name",
        "desc": "Review and name your account"
      },
      "t-cosigners": {
        "caption": "Cosigners",
        "desc": "Select the scheme and pick other signers"
      },
      "coin": {
        "title": "Coin",
        "caption": "<b>What coin is this account based on?</b><br/><br/>Account based on different coins are not interoperable."
      },
      "error": "The process of creating your new account failed",
      "error-explain": "Something went wrong. Could be a bug or just a momentary failure. Please try again in a moment and if the problem persists please contact support",
      "locked": "The server is locked",
      "locked-explain": "The process could not be completed because the server is currently running with some features disabled. It is a temporary state and should be resolved quickly",
      "summary": {
        "warn": "<b>The account composition</b> number of signatures thresholds and mandatory users <b>can not be changed</b> at a later time. Double check it is right now."
      },
      "j-side": {
        "title": "Join a multisignature account",
        "caption": "A multisignature account is shared with other users. According to the account policies it might need a majority of users to authorize transactions."
      },
      "join": {
        "title": "Enter your join code",
        "caption": "If you have been given an account join code type it below. If the operation is successful the account will appear in your dashboard.",
        "action": "join an account with a code"
      },
      "name": {
        "title": "Pick a name for your account",
        "caption": "The name is just for you to identify each account. If the account is multiuser it is not shared with your co-signers"
      },
      "complete": {
        "title": "Done!",
        "caption": "Your account was created.",
        "single": "Your new account is ready to use you can now receive payments on it and once it has a balance make payments.",
        "multi": "Multi user accounts need all the co-signers to join before they can be used. Please instruct them to join the account.",
        "name": "Name",
        "type": "Type"
      },
      "type": {
        "title": "Who is this account for?",
        "caption": "Your wallet is able to handle different account types: single and multi-user is the account for yourself or will be shared between a group of people?"
      },
      "osimple": {
        "title": "Simple Account",
        "caption": "The default account type: single user with server side signature for enhanced security."
      },
      "oadv": {
        "title": "Advanced Account",
        "caption": "Using this option you will be able to create any kind of account"
      },
      "select": {
        "title": "Press next to continue",
        "caption": ""
      },
      "totalsigs": {
        "title": "Total number of users",
        "caption": "Select the total number of users (including you) that have signing capabilities for this account."
      },
      "reqsigs": {
        "title": "Minimum Required Signatures",
        "caption": "Select the minimum number of signatures required to sign an outgoing transaction. Min: 1 Max: the number of users of the account."
      },
      "advanced": {
        "title": "Advanced Account Creation",
        "caption": "Customize your new account",
        "name": {
          "label": "Name",
          "ph": "Enter a name for the account..."
        }
      },
      "simple": {
        "title": "Simple Account",
        "caption": "You are creating a new single user account with server signature for enhanced security.",
        "name": {
          "label": "Name",
          "ph": "Please name  the new account..."
        }
      }
    },
    "limits": {
      "no-server": {
        "title": "This account has no server signature",
        "caption": "Although the Melis server tries hard to enforce the limits you set and refuses to produce a transaction that exceeds them a server signature is not required to produce such a transaction thus <b>limits can not be cryptographically enforced.</b> "
      },
      "soft": {
        "title": "Soft Limits",
        "caption": "Soft Limits need you to authorize a transaction above them using a two-factors authentication. If you spend more than the limit per period you will be prompted for an authorization code from one of your alternative two-factor methods"
      },
      "hard": {
        "title": "Hard Limits",
        "caption": "You can not go over an hard limit. You can change an hard limit but a change in a monthly limit for instance will need a month to become active"
      },
      "period": "Period",
      "treshold": "Threshold ({{unit}})",
      "lastModified": "Last modified {{when}}",
      "daily": "Daily",
      "weekly": "Weekly",
      "monthly": "Monthly",
      "none": "not set",
      "always": "always",
      "willchange": "Will change {{when}} to",
      "no-tfa": "It does not make much sense to enable soft limits without any <b>two-factors authentication</b> devices configured.",
      "set-tfa": "You can change two-factors authentication here."
    },
    "a": {
      "secure": "make secure",
      "unsecure": "set as not secure",
      "hide-show": "hide/show"
    }
  },
  "address": {
    "list": {
      "title": "Addresses"
    }
  },
  "backup": {
    "needed": {
      "title": "WARNING: you have not backed up your credentials",
      "caption": "Please back up your credentials so that you will be able access your wallet in the future. <b>If something bad happens and you don't have a back-up you could lose access to your funds</b>. You need to do this operation only once ever.",
      "action": "Backup your mnemonics now"
    },
    "nagger": {
      "title": "Remember to back up your credentials",
      "caption": "Your accounts have credit on them, double check if you have a valid backup. <br><b>If you lose your credentials you will no longer be able to access your funds! There is no recovery!</b>"
    },
    "check": {
      "action": "I have a backup. Hide this.",
      "title": "Backup Check"
    },
    "wizard": {
      "title": "Credentials Backup"
    },
    "ckw": {
      "intro": {
        "caption": "Why?",
        "descr": "Check Backup"
      },
      "pin": {
        "caption": "PIN",
        "descr": "Unlock credentials"
      },
      "mnemo": {
        "caption": "Backup",
        "descr": "Recover Backup"
      },
      "qrc": {
        "caption": "Passphrase",
        "descr": "Unlock backup"
      }
    },
    "ck": {
      "intro": {
        "title": "Verify your backup",
        "caption": "The process will guide you into verifying that you backup is still working"
      },
      "pin": {
        "title": "PIN",
        "caption": "Melis needs to unlock your credentials to check that they match the ones you have backed up"
      },
      "mnemo": {
        "title": "Mnemonics",
        "caption": "Enter the mnemonics from your backup (and press enter). If your backup is encrypted you will be asked the passphrase to decrypt it."
      },
      "or-qr": {
        "title": "Or scan your backup card",
        "caption": "You can also scan the backup card."
      },
      "cmnemo": {
        "title": "Decrypt your backup",
        "caption": "The passphrase is needed as this backup was encrypted."
      },
      "success": {
        "title": "Success!",
        "caption": "Your backup is valid."
      },
      "failure": {
        "title": "Verification failed!",
        "caption": "This backup <b>appears to be valid</b>, but does not match your credentials. Something went wrong, double check everything and try again. <b>You are advised to proceed to do a backup right now!<b>"
      },
      "err": {
        "failed-backup": "This backup appears to be valid, but does not match your credentials. <b>You are advised to proceed to do a backup right now!<b>",
        "failed-encrypted": "If the backup was encrypted it is possible that the passphrase was wrong. Please check and try again",
        "failed-check": "An error occurred while checking the bakup, and no check was done. <b>You are advised to proceed to do a backup right now!<b>",
        "pair": "The code you are scanning appears to be a pairing code",
        "invalid-scan": "The code you acquired does not seeem to be a Melis backup, but you should try again in case it has been acquired corrupted",
        "invalid-gen": "The code is a Melis backup but it has been received in a currupted way, please try again",
        "scanner": "Something went wrong with the scanner, please try again"
      }
    }
  },
  "enroll": {
    "state": {
      "idle": "Work in progress...",
      "enrolling": "Enrolling Wallet.",
      "done": "All Done.",
      "acreate": "Creating Default Account.",
      "aselect": "Selecting Account."
    },
    "btn": {
      "summary": "Access your wallet"
    },
    "tabs": {
      "backup": {
        "caption": "Backup",
        "descr": "Write down your mnemonics."
      },
      "type": {
        "caption": "Type",
        "descr": "Select an account type."
      },
      "pin": {
        "caption": "Pin",
        "descr": "Set your security PIN."
      },
      "enroll": {
        "caption": "Enroll",
        "descr": "Your account is being enrolled."
      }
    },
    "tabspanel": {
      "coin": {
        "title": "Starting coin",
        "caption": "Choose the <b>coin</b> your initial account will be based on",
        "notice": "You can create additional accounts for the same or a different coin later."
      },
      "backup": {
        "title": "This device already has the credentials for a wallet on it",
        "caption": "If you enroll a new wallet you will lose your credentials on this device. If you ever need to access this wallet you will have to use a backup. Make sure you have a backup.",
        "btn": "Backup current credentials now."
      },
      "pin": {
        "title": "Choose a PIN",
        "caption": "The PIN makes logging into your wallet from this device comfortable and secure. Just pick a simple password or a numeric code of at least 4 digits.",
        "remember": "Make sure you remember your PIN you will need it for security sensitive operations.",
        "advanced": "Advanced options",
        "skip": "Skip default simple account creation"
      },
      "type": {
        "title": "Choose your first account type",
        "caption": "You may have an unlimited number of account in your wallet. Each account can be of different kind."
      }
    },
    "failed": {
      "title": "Enroll Failed",
      "caption": "The enroll process failed. The error returned from the server was:",
      "startover": "Okay"
    },
    "locked": {
      "title": "Server is locked",
      "caption": "Your wallet has been created but we could not create an account for you because the server is running with limited capabilities. Please come back in a while the process will continue from here.",
      "startover": "Start over"
    },
    "success": {
      "title": "Enroll Complete",
      "caption": "You may now access your wallet but it's advised to make a one-time backup as the first step. You may also decide to make a backup later but make sure you do it as you receive valuable assets on your accounts.",
      "warning": "If you forget your PIN or lose your credentials and you do not have a backup you will lose your assets.",
      "backup": "Backup Your Wallet",
      "skip": "Skip backup and continue"
    },
    "walletok": {
      "title": "Your wallet has been created",
      "caption": "You chose not to create an account as part of the enroll. You now need to create your first account.",
      "createacct": "Create a new account"
    },
    "complete": {
      "title": "Warning: be careful",
      "caption": "The security of cryptocurrencies is inherently related to your credentials. if your credentials are lost/stolen there might be no ways to recover your assets. <b>Exercise the due diligence, make back-ups and store them in a safe place.</b>"
    }
  },
  "dash": {
    "account": {
      "notifications": "NOTIFICATIONS",
      "pending": "PENDING PAYMENTS"
    },
    "multi": {
      "joinwait": "Waiting for cosigners to join...",
      "joined": "{{count}}/{{total}} cosigners have joined"
    }
  },
  "license": {
    "act": {
      "reject": "Reject the license",
      "accept": "Accept",
      "reset": "Review the license"
    },
    "modal": {
      "title": "Please review the license"
    },
    "scroll-hint": "(You need to scroll completely to the bottom to accept the license)"
  },
  "mm": {
    "entries": {
      "dashboard": "Dashboard",
      "summary": "Summary",
      "account": "Account",
      "send": "Send",
      "receive": "Receive",
      "history": "History",
      "ab": "Address Book",
      "prefs": "Preferences"
    }
  },
  "netstatus": {
    "mainDisconnection": {
      "title": "Server connection lost",
      "text": "Automatic reconnection in a few seconds..."
    },
    "state": {
      "ok": {
        "label": "OK",
        "title": "Connected",
        "text": "Client is connected to the server."
      },
      "busy": {
        "label": "BUSY",
        "title": "Connecting...",
        "text": "A connection is being established"
      },
      "dc": {
        "label": "DC",
        "title": "Server not connected",
        "text": "Client has lost connection to the server"
      }
    }
  },
  "newaddr": {
    "a": {
      "alternate": "Alternate format",
      "renew": "Get a new address",
      "make-active": "Create a payment request",
      "clip": "Copy to clipboard",
      "release": "Cancel this request",
      "leave": "Rememeber and close",
      "addr-list": "Address List"
    },
    "empty": {
      "info": "[ no info set ]",
      "amount": "[ request a specific amount ]"
    },
    "generated": {
      "title": "Your generated Address",
      "caption": "Scan the QR code to receive a payment or manually cut&paste the address below"
    },
    "generate": {
      "title": "Generate a new address",
      "caption": "Please enter some meta info to associate to this address in order to add them to the incoming transactions"
    },
    "current": {
      "title": "Your payment address",
      "caption": "This address is used to receive a payment. Addresses are best used on for one payment thus it will change every time a payment is made or you can change it yourself.",
      "time": "Address generated <b>{{when}}</b>."
    },
    "active": {
      "title": "Payment Request",
      "caption": "This address will be put aside for a specific request of payment. When the payment will be made the informations inserted here will be associated to the payment record.",
      "type": {
        "bitcoin": "coin address",
        "melis": "Melis URL"
      },
      "default-ph": "Payment request"
    },
    "form": {
      "more": "More options",
      "info": {
        "label": "Info",
        "ph": "Enter informations on this address' purpose..."
      },
      "labels": {
        "label": "Labels"
      },
      "amount": {
        "label": "Amount",
        "ph": "Enter an amount to request with this adddress..."
      }
    },
    "gen-error": "There was an error with the server requesting this operation. Please try again later",
    "noresource-error": "You have too many open payment requests. You may delete a few, or contact support to have the limit raised.",
    "nocurrent": "No current Address",
    "type": {
      "generic": "Generic address",
      "request": "Payment request"
    },
    "txs": {
      "label": "Transactions",
      "none": "None received",
      "chain": "Chain",
      "hdindex": "HD Index",
      "table": {
        "txs": "TXs",
        "amount": "amount",
        "address": "address",
        "date": "date"
      }
    }
  },
  "notif": {
    "you": "You",
    "tx": {
      "sent": "The account has successfully sent {{amount}} {{unit}}",
      "received": "The account has received {{amount}} {{unit}}"
    },
    "ptx": {
      "proposed": "{{source}} has proposed a new transaction for {{amount}} {{unit}}",
      "has-approved": "{{source}} has approved a pending transaction",
      "has-contributed": "{{source}} has contributed to a pending transaction"
    },
    "evt": {
      "has-joined": "<b>{{subject}}</b> has successfully joined the account '<span class='text-warning'>{{account}}</span>' {{time}}",
      "wall": "{{text}}",
      "wall-title": "Notification from service"
    }
  },
  "paysend": {
    "tx-done": "Transaction completed successfully",
    "tx-success": "Transaction successfully submitted",
    "sources": {
      "auto": "Automatic selection of inputs"
    },
    "remainder": {
      "auto": "Automatically handle the remainder"
    },
    "fees": {
      "auto": "Automatic selection of fees"
    },
    "funds": {
      "title": "Unconfirmed Funds",
      "caption": "You have unconfirmed funds that are currently not available. They will be back in your availability in minutes.",
      "unconfirmed": "unconfirmed",
      "available": "available"
    },
    "no-coins": {
      "title": "You have no coins",
      "caption": "This account does not have a balance. So you can not send any coins until you have some"
    },
    "prompts": {
      "prepare": "Prepare payment.",
      "sign": "Approve Payment",
      "cancel": "Cancel Payment"
    },
    "err": {
      "occurred": "An error occurred while preparing the transaction: {{error}}",
      "prepare-fail": "Could not prepare Transaction",
      "no-funds": "insufficient funds.",
      "addr-dup": "This Address is already part of this transaction."
    },
    "success": "Success!",
    "tx-signed": "Payment successfully approved.",
    "tx": {
      "failv": {
        "title": "The transaction is failing validations",
        "caption": "Melis wallet performs client-side checks on the transaction the server provides us. This one has failed validations. It is probably just a bug a not actually the server trying to trick us but its safe not to proceed"
      },
      "review": {
        "title": "Review your transaction",
        "caption": "Please note that confirmed transactions are final and can't be reversed"
      },
      "review-onemulti": {
        "title": "This transaction only needs one signature",
        "caption": "This is a multisignature account but this transaction only needs one signature. You can sign it now and the transaction will be valid or you can propose it now and let one of your cosigners (or yourself) approve it later."
      },
      "review-multi": {
        "title": "This transaction requires multiple signatures",
        "caption": "You need some of your cosigners to approve this transactions in order for it to be sent through. You can approve it now or just propose it and let your cosigners (or yourself) approve it at a later time."
      },
      "disc": {
        "prompt": "Type a message to your co-signers"
      },
      "info": {
        "sigs-req": "Signatures Required",
        "cosig": "co-signers",
        "mandatory": "Yours is mandatory",
        "fees": "Fees:",
        "total": "Total: ({{unit}})"
      },
      "a": {
        "cancel": "Cancel this Transaction",
        "propose": "Propose this Transaction",
        "confirm": "Propose and approve this Transaction",
        "approve": "Approve this Transaction"
      }
    },
    "head": {
      "title": "Send money",
      "caption": "Please enter the amount and the recipient(s) of the transaction"
    },
    "sum": {
      "sources": "Inputs",
      "dsts": "Destinations",
      "remainder": "Remainder (inc fees)",
      "fees": "Fees"
    },
    "form": {
      "a": {
        "confirm": "Confirm Transaction",
        "discard": "Discard Transaction",
        "recpconf": "Confirm Recipient",
        "recpdisc": "Discard Recipient",
        "recpadd": "Add Recipient"
      },
      "acc": {
        "sources": "Inputs",
        "destinations": "Destinations",
        "remainder": "Remainder",
        "options": "Options"
      },
      "insuff-funds": "Insufficient funds.",
      "not-bitcoin": "Not a coin adddress.",
      "entire-balance": "Entire balance",
      "entire-balance-r": "Remaining balance",
      "entire-sources": "Selected inputs",
      "entire-sources-r": "Remaining inputs",
      "more": "Add more informations",
      "scan": "Scan an address",
      "ab": "Pick address from addressbook",
      "clipboard": "Paste address from clipboard",
      "type": "Type of recipient",
      "recipient": {
        "label": "Recipient Address",
        "ph": "Enter a recipient address..."
      },
      "amount": {
        "label": "Amount",
        "ph": "Enter the amount to send..."
      },
      "currency": {
        "label": "Currency"
      },
      "labels": {
        "label": "Labels"
      },
      "info": {
        "label": "Info",
        "ph": "These info will be stored for your reference..."
      },
      "memo": {
        "label": "Memo",
        "ph": "These info will be sent to the recipient, if possible."
      },
      "pubid": {
        "label": "Melis Account",
        "ph": "Search an alias or Public ID"
      },
      "account": {
        "label": "Your Account",
        "ph": "Select one of your accounts"
      },
      "unc": "Allow unconfirmed funds",
      "rbf": "RBF",
      "fees": "Fees",
      "feesperbyte": "Fees per byte: (satoshi, {{unit}})",
      "fees-provider": "Retrieved from {{provider}}",
      "feesrefresh": "refresh",
      "feesnr": "Can't determine fees"
    }
  },
  "prefs": {
    "alias": {
      "is": "Your alias is:",
      "not-set": "Your alias is not set",
      "change": "Define alias",
      "ableto": "You will be able to set your account alias when you have total of at least {{amount}} in your wallet.",
      "unableto": "You don't meet the criteria for changing the alias yet",
      "once": "Notice that the alias can be changed only <b>once</b>",
      "taken": "Alias is taken",
      "ph": "Choose a new alias",
      "button": "Yes change my alias",
      "not-ready": "... getting info ...",
      "already-def": "Your alias has been set. Aliases cannot be changed as they uniquely identify you in the system."
    },
    "pin": {
      "changed": "Pin changed with success",
      "failure": " Pin was not changed",
      "button": "Change pin"
    },
    "profile": {
      "identity": "Public Identity: ",
      "alias": "Alias: ",
      "name": "Name: ",
      "address": "Address: ",
      "profile": "Profile: "
    },
    "tfa": {
      "title": "2-factors Authentication",
      "caption": "Use a second factor authentication to better secure your account and authorize payments"
    }
  },
  "public": {
    "login": {
      "prompt": "Login to "
    },
    "payto": {
      "app": "PAY TO",
      "caption": "Send coins<br>easily<br>to any Melis account",
      "total": "Total ({{unit}}):",
      "showcode": "Show the payment address",
      "error": {
        "noaddr": "An error occurred while getting the payment address. <b>Please try again later.</b>"
      },
      "amount": {
        "ph": "Enter the amount to send."
      },
      "note": {
        "title": "Enter a note for the recipient.",
        "not-set": "[ not-set tap to edit ]"
      },
      "scan": {
        "title": "Scan this barcode",
        "caption": "Direct your wallet to this barcode and scan the address it contains. Then make your payment to it."
      },
      "sign": {
        "title": "Open your wallet",
        "caption": "This device has saved Melis credentials. You can unlock them and quickly pay from your accounts."
      },
      "curr": {
        "enter": "Enter a value in fiat currency"
      }
    },
    "join": {
      "app": "JOIN",
      "caption": "Send coins<br>Easy<br>to any Melis account",
      "explain": {
        "title": "You have been asked to join a shared account",
        "caption": "Access your wallet to automatically create a new multiuser account with the user that gave you this join code"
      },
      "enroll": {
        "pin": {
          "title": "PIN Input",
          "caption": "odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolore"
        },
        "no-creds": {
          "title": "You do not seem to have credentials on this device.",
          "caption": "If you already own a Melis wallet please access this join url from the device where you normally access it. Otherwise open your wallet and manually enter the join code"
        },
        "button": "Enroll for a Wallet"
      },
      "success": "Account joined Successfully",
      "error": "An error accurred while joining. Try again later.",
      "not-found": "An error accurred while joining. This join code was not found."
    },
    "profile": {
      "app": "PROFILE",
      "caption": "Send coins<br>Easy<br>to any Melis account",
      "no-profile": "this account exists but has released no public profile data."
    },
    "error": {
      "no-tx": {
        "title": "This transaction is unavailable",
        "caption": "The transaction you are looking for was not found."
      }
    }
  },
  "qr": {
    "scan": {
      "errors": {
        "media-error": "There was an error accessing the camera. You could either try a different browser or use our native application.",
        "no-um": "Your Browser or Platform does not support our way of getting access to the camera. You could either try a different browser or use our native application.",
        "no-perms": "<b>Melis could not access the camera to acquire images.</b> Please check you have given the appropriate permissions. Otherwise you may not have a supported camera or your platform is not supported."
      },
      "accept": "ok",
      "dismiss": "Dismiss",
      "scan": "Scan",
      "upload": "Upload"
    }
  },
  "qrupload": {
    "action": {
      "drag": "Drag an image of a QR Code here to acquire it",
      "valid": "Drop the image here",
      "invalid": "Unsupported image format"
    },
    "btn": {
      "cancel": "Discard the address",
      "ok": "Confirm address"
    }
  },
  "quicksend": {
    "title": "Pay from your accounts",
    "caption": "You can quickly pay here from one of your accounts.",
    "account": "Active account",
    "to": "To:",
    "balance": "Balance:",
    "available": "Available:",
    "success": "The operation was successful.",
    "error": {
      "addr": "Unable to get a payment address for the recipient",
      "pay": "Unable to complete the transaction"
    }
  },
  "recover": {
    "import": {
      "title": "Scan your backup",
      "caption": "Point the camera at the barcode at the middle of your backup card. And click below.",
      "wrongsig": {
        "title": "Your backup data is invalid",
        "caption": "We tried to recover this backup but the credentials it contained were rejected by the server.",
        "warn": "The most likely cause is that the passphrase was incorrect. Please double check it and try again"
      },
      "success": {
        "title": "Your backup has been imported",
        "caption": "You can now access your accounts on this device"
      },
      "passphrase": {
        "title": "Your backup is passphrase protected",
        "caption": "When you created this backup you decided to protect it with a passphrase. Now you need the passphrase to import it.",
        "ph": "Enter the passphrase"
      },
      "setpin": {
        "title": "Choose a new PIN for this device",
        "caption": "Protect this device with a simple PIN for secure and quick login."
      },
      "qrcode": {
        "caption": "Scan",
        "descr": "Scan the backup"
      },
      "pass": {
        "caption": "Passphrase",
        "descr": "Enter the passphrase"
      },
      "pin": {
        "caption": "PIN",
        "descr": "Set a new PIN"
      }
    }
  },
  "stream": {
    "warning": {
      "skew": "The clock on this device might be off. This can cause some informations to be displayed incorrectly"
    },
    "helper": {
      "ptx": {
        "title": "",
        "caption": "created by: {{by}}"
      },
      "tx": {
        "title": "",
        "caption": ""
      },
      "address": {
        "title": "Payment request"
      }
    },
    "txm": {
      "has-contributed": "has contributed to this",
      "has-signed": "has signed this",
      "has-approved": "has approved this",
      "ptx": "proposed transaction"
    },
    "hwm": {
      "new-events": {
        "one": "There is a <b>new event</b>.",
        "other": "There are <b>{{count}} new events</b>."
      },
      "show": "Show.",
      "outdated": {
        "title": "There might be a newer version",
        "caption": "An updated version of this application might be out. According to your platform you might want to check for updates, or head to the website."
      }
    },
    "evt": {
      "wall": "Notification from service",
      "has-joined": "<b>{{subject}}</b> has successfully joined the account '<span class='text-warning'>{{account}}</span>' {{time}}",
      "tfad": {
        "title": "Two Factors recovery requested!",
        "caption": "Someone, maybe you, has requested for all your second factors authentication devices to be reset and disabled.<b>This has serious security implications.</b>",
        "expire": "If you don't do anything they will be disabled <b>{{time}}.</b>",
        "canceled": "The request has been canceled."
      },
      "tfad-cancel": {
        "title": "Two Factors recovery canceled",
        "caption": "The last recovery request was canceled."
      },
      "devdel": {
        "title": "A device has been deleted from the wallet",
        "caption": "The device '<b>{{label}}</b>' has been disassociated <b>{{time}}</b>from this wallet and will not be able to access it without mnemonics."
      },
      "newd": {
        "title": "A new device has been registered",
        "caption": "A new device '<b>{{label}}</b>' has been registered to access this wallet <b>{{time}}</b>."
      },
      "newp": {
        "title": "Primary device has changed",
        "caption": "The device '<b>{{label}}</b>' has become the primary device <b>{{time}}</b>."
      },
      "newp-f": {
        "title": "The primary device will change",
        "caption": "The device '<b>{{label}}</b>' will become the primary device <b>{{time}}</b>."
      },
      "newp-s": {
        "title": "Primary device has changed",
        "caption": "This device ('<b>{{label}}</b>') has become the primary device <b>{{time}}</b>."
      },
      "newp-sf": {
        "title": "The primary device will change",
        "caption": "This device ('<b>{{label}}</b>') will become the primary device <b>{{time}}</b>."
      }
    },
    "ph": {
      "started": "Your account is ready!",
      "welcome": "This page will contain the list of activities on your account. Check out the other sections in the menu on the left.",
      "address": "This is the address to send your first coins to:"
    },
    "tx": {
      "fees": "Fees",
      "bump": "Fees Bump",
      "rbf": "RBF",
      "invalidated": "This transaction was superceded and invalidated.",
      "sent": "Transaction successfully sent {{time}}",
      "received": "Transaction received {{time}}",
      "amount": "Amount: ",
      "to": "To: ",
      "received-ad": "On address:",
      "hash": "TxID",
      "a": {
        "ok": "Ok"
      }
    },
    "ptx": {
      "details": "Details.",
      "created": "Transaction proposal created by <b>{{creator}}</b> {{time}}.",
      "rotation": "Unspent input rotation created by <b>{{creator}}</b> {{time}}.",
      "respent": "Transaction has been automatically cancelled because another transaction has used its inputs",
      "feebump": "This is a fee bump proposal, if you approve this it will supercede an existing transaction with different fees.",
      "canceled": "Transaction has been cancelled",
      "recipients": "Recipients:",
      "multiple": "Multiple Recipients",
      "amount": "Amount: ",
      "fees": "Fees:",
      "sigs-req": "Signatures required",
      "cosigners-no": "{{count}} Co-signers",
      "is-mandatory": "Yours is mandatory",
      "chat-prompt": "Send a message to your co-signers",
      "a": {
        "approve": "Approve this transaction",
        "cancel": "Delete this transaction",
        "reissue": "Reissue this transaction"
      }
    },
    "addr": {
      "generated": "Payment request generated <b>{{when}}</b>",
      "used-in": {
        "one": "Used in a transaction.",
        "other": "Used in <b>{{count}}</b> transactions."
      },
      "see-it": "See it.",
      "a": {
        "cancel": "Cancel this request."
      }
    }
  },
  "ticker": {
    "history": {
      "d": "LAST 24H",
      "m": "LAST 30D"
    }
  },
  "tfa": {
    "recovery": {
      "action": "Help, I have lost all my devices!",
      "title": "Two Factors Authentication recovery",
      "caption": "If you have lost <b>all</b> your 2-factors devices, you may initiate a recovery procedure here. <b>The procedure will disable all your device in a month from now</b>. For security reasons there no way to make it moe expedited",
      "done": {
        "title": "Your request has been acquired",
        "caption": "Your devices will be disabled in a month from now. <b>Please note that using any of them before this time expires will cancel the recovery process</b>"
      },
      "error": {
        "title": "There was an error",
        "caption": "There was an error while registering the request, please try again in a minute."
      }
    },
    "actions": {
      "token-sent": "Token Sent.",
      "enable": "Enable",
      "enroll": "Enroll",
      "error": "There was an error."
    },
    "devices": {
      "email": "Email",
      "sms": "Text",
      "xmpp": "XMPP",
      "telegram": "Telegram",
      "matrix": "Matrix",
      "rfc6238": "Authenticator Device",
      "regtest": "Regtest",
      "unknown": "Unknown Device"
    },
    "state": {
      "title": "Two Factors Authentication",
      "caption": "Please enable at least one TFA device to secure your wallet",
      "disabled": "Two factors authentication is disabled.",
      "complete": {
        "title": "Active Devices"
      },
      "incomplete": {
        "title": "Please complete the enroll of your 2-factors device",
        "caption": "Provide a token now to finish enrolling the device. The device will be active once the enroll process is over."
      },
      "expire": "Scheduled to expire {{when}}."
    },
    "types": {
      "email": "Email",
      "sms": "Text",
      "xmpp": "Jabber/XMPP",
      "telegram": "Telegram",
      "matrix": "Matrix",
      "rfc6238": "Authenticator App",
      "u2f": "U2F key",
      "regtest": "Regtest"
    },
    "token": {
      "title": "Send Token",
      "caption": "A numeric code will be sent to the selected device. It is possible to send it again in case it is not received but only the last code sent will be considered valid",
      "button": "send",
      "form": {
        "token": {
          "label": "Token",
          "ph": "Enter the token."
        }
      }
    },
    "email": {
      "title": "Email",
      "caption": "Use an email address where the system will send the authorization code",
      "invalid": "Not a valid email address",
      "form": {
        "email": {
          "label": "Email",
          "ph": "Enter the email address"
        }
      }
    },
    "telegram": {
      "title": "Telegram",
      "caption": "Enter a telegram username where you want to receive authorization codes",
      "invalid": "Not a valid telegram username",
      "bot": "Send a message to the Telegram bot:",
      "code": "containing the following code:",
      "explain": "Then enter here the code the bot replies to you:",
      "form": {
        "address": {
          "label": "Username",
          "ph": "@telegram_username"
        }
      }
    },
    "matrix": {
      "title": "Matrix",
      "caption": "Enter a matrix username where you want to receive authorization codes",
      "invalid": "Not a valid matrix username",
      "bot": "Send a message to the Matrix bot:",
      "code": "containing the following code:",
      "explain": "Then enter here the code the bot replies to you:",
      "form": {
        "address": {
          "label": "Username",
          "ph": "@matrix_username"
        }
      }
    },
    "sms": {
      "title": "SMS/Text",
      "caption": "A mobile number where the system will text the authorization code",
      "invalid": "Not a valid mobile number",
      "form": {
        "sms": {
          "label": "Number",
          "ph": "+CC AAA NNNNNNN"
        }
      }
    },
    "xmpp": {
      "title": "XMPP/Jabber",
      "caption": "You can use your jabber or gtalk account to receive an authorization code",
      "invalid": "Not a valid xmpp/jabber address",
      "form": {
        "address": {
          "label": "XMPP Address",
          "ph": "Enter the XMPP address"
        }
      }
    },
    "rfc6238": {
      "title": "Authenticator App",
      "caption": "Enable a TOTP device like Google Auth or Authy",
      "explain": "Please scan this QR code with your device and provide the code below:"
    },
    "regtest": {
      "title": "Regtest",
      "caption": "Used for regression testing",
      "form": {
        "identifier": {
          "label": "Identifier",
          "ph": "Enter the identifier"
        }
      }
    },
    "pin": {
      "label": "Your PIN",
      "wrong": "Wrong PIN",
      "left": "{{count}} attempts left",
      "ph": "Enter your PIN",
      "last-attempt": "Last Attempt!",
      "nocreds": {
        "title": "No credentials on this device",
        "caption": "For security reason this device has been invalidated and credentials removed."
      }
    }
  },
  "toasts": {
    "stream": {
      "urgent": {
        "one": "Account '<b>{{name}}</b>' has a new event that might require your attention.",
        "other": "Account '<b>{{name}}</b>' has {{count}} new <b>important</b> events."
      },
      "entries": {
        "one": "Account '<b>{{name}}</b>' has a new event.",
        "other": "Account '<b>{{name}}</b>' has {{count}} new events."
      }
    },
    "ptx": {
      "cosigner": "A cosigner",
      "newtx": "{{owner}} has proposed a new transaction for account: {{account}}",
      "newsig": "{{signer}} has signed a transaction for account: {{account}}"
    }
  },
  "tx": {
    "you": "You",
    "you-s": "You",
    "fees": {
      "verylow": "Very Low",
      "low": "Low",
      "normal": "Normal",
      "high": "High",
      "veryhigh": "Very High"
    },
    "list": {
      "title": "Transactions",
      "from": "Starting from:",
      "no-results": "There are no recorded transactions for this account"
    },
    "detail": {
      "rbf": "RBF",
      "moreinfo": "More Informations",
      "to": "To",
      "fees": "Fees",
      "info": "Custom notes",
      "labels": "Labels",
      "amount": "Amount",
      "hash": "TxID",
      "address": "To Address",
      "received-ad": "On address",
      "orig-currency": "(originally {{amount}}{{unit}} - {{when}})",
      "ptx": {
        "sigs": "Signatures",
        "cosigners-no": "{{count}} co-signers"
      }
    },
    "discussion": {
      "has-approved": "has approved this transaction.",
      "no-messages": "No messages in this discussion...",
      "enter": "enter your message"
    },
    "signers": {
      "not-signed": "not signed"
    },
    "txs": {
      "title": "You have proposed transactions that require your attention",
      "caption": "These transactions are still waiting for one or more co-signers to approve them. They are listed here for your convenience"
    },
    "notxs": {
      "title": "There are no proposed transactions that are unprocessed",
      "caption": "All your transactions have been approved and published."
    },
    "prepared": {
      "to": "To:",
      "state": "State:",
      "recipients": "Recipients:",
      "created": "Transaction proposal created by <b>{{creator}}</b> {{time}}.",
      "amount": "Amount:",
      "signedby": "Signed by:",
      "discussion": "Discussion:",
      "createdby": "Created by:",
      "signatures": "Signatures:",
      "multiple": "Multiple",
      "notsigned": "Not Signed",
      "approve": "Approve",
      "owner": "Owner",
      "cancancel": "You can cancel this transaction",
      "notapproved": {
        "title": "This transaction is waiting for your approval.",
        "caption": "This transactionhas been proposed under this account but is missing one or more approvals including yours in order to be completed. Please review the transaction proposed below"
      },
      "approved": {
        "title": "You have already signed this transaction",
        "caption": "You have approved this transaction but it is still pending as it has not received enough approvals to be valid."
      },
      "a": {
        "approve": "Approve this Transaction",
        "cancel": "Cancel this Transaction"
      }
    }
  },
  "urgent": {
    "tx": {
      "title": "Hello this might require some attention.",
      "caption": "A proposed transaction waits for your action the details are below.",
      "link": "More details here."
    }
  },
  "view": {
    "details": ": details.",
    "side": {
      "nav": {
        "history": "History",
        "addresses": "Addresses",
        "unspents": "Unspents"
      },
      "wallet": {
        "title": "Wallet details",
        "caption": "Here you can find the details of your wallet"
      },
      "account": {
        "title": "Account details",
        "caption": "Here you can find the details of your account"
      },
      "backup": {
        "status": "Backup status"
      },
      "movements": {
        "title": "Expenses",
        "day": "Today:",
        "week": "This week:",
        "month": "This month:"
      },
      "balance": {
        "title": "Balance",
        "caption": "Detailed coin types",
        "available": "Available",
        "reserved": "Reserved",
        "unconfirmed": "Unconfirmed",
        "unmature": "Unmature"
      },
      "multi": {
        "title": "Multisignature",
        "alljoin": "All Cosigners have joined.",
        "joined": "Cosigners joined",
        "joinwait": "Waiting for Cosigner to join",
        "fees": "This account fees are approximately <span class='label'>{{fees}}x</span> compared to a single-user account"
      }
    },
    "tabs": {
      "preferences": "Preferences",
      "coins": "Coins",
      "vitals": "Cosigners",
      "history": "History",
      "security": "Security",
      "maintenance": "Maintenance",
      "utilities": "Utilities",
      "limits": "Spending limits",
      "devices": "Devices",
      "accounts": "Accounts",
      "nlock": "Recovery"
    },
    "recovery": {
      "title": "Account recovery",
      "caption": "In the event the server should become unavailable, the informations in this page will help you recover your funds"
    },
    "nlock": {
      "title": "Account recovery",
      "caption": "This is an account with <b>Server signature</b>. This tool will help you recover your funds in the event the server is not available",
      "reminder": {
        "title": "Some of your unspents are expired, or expiring soon.",
        "caption": "Expired unspents cannot offer the same degree of protection. They might be renewed automatically if you make a transaction, or you can renew them here."
      },
      "recovery": {
        "title": "Recovery file",
        "caption": "A recovery file can be used with the <b>Melis Recovery Tool</b> in the event the server is unavailable, to recover your funds",
        "retr": "There is a recovery file ready",
        "time": "Current recovery time is <b>{{days}} days</b>.",
        "disabled": "Recovery time is disabled. <b>Be aware this can have consequences on your ability to recover your funds in case the server becomes unavailable.</b>",
        "nofile": "There is no recovery file ready, try refreshing to fetch one",
        "info": "These are the recovery informations for your account",
        "nomail": "On this platform, recovery files are sent to you by mail. Please set up email on your system."
      },
      "unspents": {
        "title": "Expiring Unspent Transactions",
        "caption": "Unspent transactions need to be renewed before they expire in order to be able to keep the security provided by having a server signature, and the ability to recover your funds in case the server might get unavailable.",
        "block": "confirms",
        "expires": "expiration",
        "amount": "amount",
        "none": "There are no expiring unspents."
      },
      "transaction": {
        "title": "Confirm the transaction",
        "caption": "Rotating unspents incurs in network fees as it is a normal transaction:",
        "fees": "Fees:",
        "error": "An error occurred when performing the requested operation"
      },
      "tx": {
        "multi": "This is a multisignature account, you co-signers will need to complete the approval of this transaction.",
        "success": "Unspents have been successfully rotated"
      },
      "rotate": {
        "all": "Renew all",
        "some": {
          "one": "Renew selected unspent",
          "other": "Renew {{count}} unspents"
        }
      },
      "time": {
        "ph": "change the time",
        "current": "current value",
        "1mo": "1 month",
        "3mo": "3 months",
        "6mo": "6 months",
        "disabled": "disabled"
      },
      "url": {
        "title": "Recovery application",
        "caption": "In case this application becomes unavailable, you can recovery your funds with the (static) app at these addresses"
      }
    },
    "prefs": {
      "title": "Account preferences",
      "type": "type",
      "account": {
        "num": "Account Number:",
        "name": "Account Name:",
        "created": "Created:",
        "color": "Color:",
        "identifier": "Identifier:"
      },
      "profile": {
        "title": "Public profile",
        "caption": "These informations are public. They are visible on your profile page on Melis website and other users can find them with Melis profile search."
      },
      "alias": {
        "title": "Alias",
        "caption": "An alias is an unique name you use to identify yourself within Melis"
      },
      "ident": {
        "title": "Public Identity",
        "caption": "Use this identifier to enable third parties to send you payments and messages"
      }
    }
  },
  "wallet": {
    "title": "Wallet Settings",
    "no-creds": {
      "title": "This device is no longer enabled to access your wallet",
      "caption": "It's not possible to access your wallet from this device. You will have to pair it again, or recover credentials from a backup."
    },
    "options": {
      "enroll": "Enroll for a new wallet",
      "pair": "Pair this device",
      "recover": "Import from a backup card",
      "import": "Open a wallet from mnemonics"
    },
    "prefs": {
      "title": "Preferences",
      "caption": "Display preferences",
      "notif": {
        "title": "Notifications",
        "caption": "Notifications will alert you of relevant events in real time",
        "native": {
          "t": "Desktop Notifications",
          "c": "Desktop notifications will appear on your desktop when the application is not in focus"
        },
        "inapp": {
          "t": "In-App Notifications",
          "c": "In-App notifications appear on the application while you are using it"
        },
        "push": {
          "t": "Push Notifications",
          "c": "Push notifications are shown on your device when the application is closed"
        }
      },
      "app": {
        "title": "This Application",
        "caption": "Informations about the Melis Wallet app.",
        "version": "Version",
        "network": "Network",
        "license": "License",
        "review": "review license"
      },
      "coinunit": {
        "title": "Coin Unit",
        "caption": "Choose your preferred Coin unit"
      },
      "currency": {
        "title": "Currency",
        "caption": "Choose your preferred fiat currency",
        "pholder": "Global Currency"
      },
      "exchange": {
        "title": "Reference exchange",
        "caption": "The exchange to get the value of this coin from"
      },
      "locale": {
        "title": "Language",
        "caption": "Select the preferred locale"
      },
      "explorer": {
        "title": "Transaction explorer",
        "caption": "Select the external service used to display the status of a transaction."
      },
      "fp-avail": {
        "title": "Fingerprint authentication",
        "caption": "This system supports fingerprint authentication but no fingerprints are acquired. You need to scan your fingerprint in the system preferences"
      },
      "fingerprint": {
        "title": "Fingerprint authentication",
        "caption": "With fingerprint authentication you will be able to use your fingerprint whenever a PIN is required (included signing in)",
        "label": "enable fingerprint authentication"
      },
      "telemetry": {
        "title": "Debug informations",
        "caption": "Melis collects informations about your application in case of exceptional events"
      },
      "t-error": {
        "t": "Send error data",
        "c": "Send informations about errors and exceptions to Melis for the only purpose of resoving bugs and issues."
      }
    },
    "devices": {
      "title": "List of devices that accessed your wallet",
      "caption": "In this section you can manages the device you used to access your wallet and you can pair another device if you want",
      "prchange": {
        "title": "Delay for changing primary",
        "caption": "For security reasons the change of primary has a delay",
        "days": {
          "one": "<b>A day</b>",
          "other": "<b>{{count}} days</b>."
        }
      },
      "non-prim": {
        "title": "This device is not a primary",
        "caption": ""
      },
      "name": {
        "title": "This device name",
        "caption": ""
      },
      "primary": {
        "title": "This is the primary device",
        "caption": "The primary device has control on the other devices and can see the secure accounts",
        "scheduled": "Another device is scheduled to become primary <b>{{relative}}</b> at {{when}}",
        "willchange": "This device will become a primary <b>{{relative}}</b> at {{when}}",
        "make": "Make this device primary",
        "cancel": "Nope, keep this as primary"
      },
      "list": {
        "name": "Device name",
        "last": "Last access",
        "new-prim": "new primary",
        "this": "this",
        "promote": "Make this device the primary",
        "delete": "Forget this device",
        "deleteall": "Delete <b>all</b> other devices",
        "wpromote": {
          "title": "Promote to primary, attention",
          "caption": "Promoting another device as primary will cause this device to lose access to some features. It will specifically lose access to any account se as <b>secure</b>. <i>Promoting to primary is immediate</i>"
        },
        "wdelete": {
          "title": "Delete a device attention",
          "caption": "If you delete and disassociate a device you will not be able to access your wallet from that device. You will need to recover a backup or pair it again."
        }
      },
      "delete": {
        "title": "Log off devices",
        "caption": "You may log all the other devices off Melis. They will need the full mnemonics, or a backup, to log back in."
      },
      "pair": {
        "title": "Pair a new device",
        "caption": "You can have many devices accessing this wallet. Pairing one is as easy as taking a photograph",
        "warn": "Be careful though paring a new devices will give access to your funds or sensitive informations to anyone knowing or guessing your PIN."
      }
    },
    "maint": {
      "title": "Maintenance",
      "caption": "In this page you can access various utilities. This page will be re-organized in a future version.",
      "backup": {
        "title": "Credentials Backup",
        "caption": "Use this wizard to back up your credentials so you can access your funds anywhere and restore access to your wallet if this device should stop working.",
        "btn": "Do backup now"
      },
      "backupck": {
        "title": "Backup Verification",
        "caption": "Check if a backup card or mnemonics is working.",
        "btn": "Check my Backup"
      },
      "new": {
        "title": "New Account",
        "caption": "Create a new account. You can choose many account types single user or multiuser with or without server signature.",
        "btn": "Create new account"
      },
      "join": {
        "title": "Join Multisignature Account",
        "caption": "If you have a join code you can use it here to join an account as a cosigner",
        "btn": "Join Account"
      },
      "pin": {
        "title": "Change Pin",
        "caption": "Use this wizard to change the PIN used to access the encrypted mnemonics on this device"
      },
      "danger": {
        "title": "Danger Zone",
        "caption": "This will enable dangerous operations"
      },
      "delete": {
        "title": "Delete credentials",
        "caption": "Deletes the credential stored in this device. You will need your mnemonics to access your wallet again.",
        "btn": "DELETE"
      },
      "wdelete": {
        "title": "DELETE CREDENTIALS",
        "caption": "This will delete all credentials from this device. You will need to use another device, or a backup to recover your funds. <b>Are you really sure?</b>"
      }
    },
    "signed": {
      "noacct": {
        "title": "You have no accounts yet",
        "caption": "You need to create your first account to start receiving coins"
      },
      "create": "Create your first account",
      "success": {
        "title": "Alpha release warning",
        "caption": "This is pre-release software: please use accordingly and do not trust the system with too many funds",
        "link": "Go to Dashboard"
      }
    },
    "signin": {
      "error": {
        "short": "Sign-in error",
        "invalid": "Invalid Device",
        "generic": "An error occurred with the server while signing-in. Please try again in a moment.",
        "wrong": "Wrong PIN. {{attempts}} attempts left."
      },
      "prompt": "Enter PIN for saved mnemonics",
      "pin": "PIN",
      "barred": {
        "title": "This version of the client is no longer supported",
        "caption": "This version of the client is old and it's no longer compatible with the service. Please update it, so you will be able to continue using it."
      },
      "locked": {
        "title": "PIN login disabled",
        "caption": "Your PIN-encrypted credentials have been deleted from this device. You must login using your full mnemonics or recover a back up."
      },
      "last": {
        "title": "One attempt left",
        "caption": "You only have one last attempt for logging in with PIN. If you enter again the wrong PIN you will need a back-up card or the full mnemonics to login again."
      },
      "new": "Create New Wallet"
    },
    "sidebar": {
      "about": {
        "title": "About",
        "caption": "Your cross-account global preferences"
      },
      "backup": {
        "title": "Credentials backup",
        "never": "never",
        "confirmed": "Last performed:",
        "checked": "Last verified:"
      }
    },
    "passphrase": {
      "pass": {
        "label": "Enter a passphrase",
        "ph": "passphrase..."
      },
      "check": {
        "label": "Repeat the passphrase",
        "ph": "passphrase..."
      }
    },
    "pin": {
      "set": {
        "label": "New PIN",
        "ph": "Enter a new pin..."
      },
      "check": {
        "label": "Repeat PIN",
        "ph": "repeat the new pin..."
      },
      "label": "PIN",
      "ph": "Enter your current pin...",
      "left": "{{count}} attempts left",
      "nocreds": {
        "title": "No Valid Credentials",
        "caption": "This client does not have any valid credential for a wallet."
      }
    },
    "mnemo": {
      "input": {
        "label": "Account Mnemonics",
        "ph": "Enter encrypted or plaintext mnemonics..."
      },
      "pass": {
        "label": "Passphrase",
        "ph": "Enter the passphrase to decrypt mnemonics...",
        "clip": "Insert from clipboard"
      }
    },
    "import": {
      "w": {
        "t-check": {
          "caption": "Are You Sure?",
          "desc": "Careful here"
        },
        "t-mnemonics": {
          "caption": "Mnemonics",
          "desc": "Type your mnemonics"
        },
        "t-pin": {
          "caption": "PIN",
          "desc": "Set your PIN"
        },
        "t-open": {
          "caption": "Open",
          "desc": "Accessing your wallet accounts"
        },
        "warn": {
          "title": "Be very careful. Pairing or importing a new wallet destroys your current credentials.",
          "caption": "This device has already the credentials for a wallet on it. If you proceed now you will destroy them. You will lose access to that wallet unless you have a backup."
        },
        "input": {
          "title": "Mnemonics Backup",
          "caption": "Input the list of words associated to the backup of your wallet. If you have a backup card it is written in the bottom of the page."
        },
        "pin": {
          "title": "PIN",
          "caption": "Define a PIN to protect your device"
        },
        "importing": {
          "title": "Importing data",
          "caption": "Your mnemonics are being decoded and the server accessed to import data"
        },
        "done": {
          "title": "Done",
          "caption": "You correctly opened your wallet."
        },
        "wrong": {
          "title": "Wrong Credentials",
          "caption": "Either the passphrase or the mnemonics are incorrect and Melis can not open your wallet",
          "warn": "The backup was encrypted so the chance is you forgot your passphrase or typed it incorrectly. You should double check it and try again."
        },
        "failed": {
          "title": "An error occurred importing the wallet",
          "caption": ""
        },
        "noacc": {
          "title": "This wallet has no accounts",
          "caption": "The wallet you just opened has no visible accounts. You may now create a new one"
        },
        "createacct": "Create a new account",
        "summary": "Your wallet"
      }
    },
    "backup": {
      "ok": "Mnemonics backup complete",
      "missing": "Mnemonics backup not done!",
      "w": {
        "t-pin": {
          "caption": "PIN",
          "desc": "Enter your current PIN"
        },
        "t-export": {
          "caption": "Export",
          "desc": "A passphrase to protect your mnemonics"
        },
        "t-backup": {
          "caption": "Backup",
          "desc": "Write down your mnemonics"
        },
        "t-confirm": {
          "caption": "Confirm",
          "desc": "Confirm your backup"
        },
        "complete": {
          "title": "Did you know?",
          "caption": "This backup is the only one you ever need no matter how many accounts and transactions you will manage on your wallet. Keep it in a very safe place.",
          "summary": "Access your wallet"
        },
        "pin": {
          "title": "Accessing your credentials",
          "caption": "The backup operation needs you enter your current PIN to access the credentials that are stored encrypted in your device."
        },
        "pass": {
          "title": "Encrypt your backup",
          "caption": "It is possible to encrypt your backup with a passphrase. Encrypting the backup makes it safe even if someone else has access to the backup card or the mnemonics as they will need the passphrase to use them.",
          "warn": "If you encrypt your backup make sure you do not forget the passphrase. If you do there is no way to recover it. Your backup will be useless and your funds could be lost.",
          "unencrypted": "Export unencrypted credentials.",
          "encrypted": "Encrypt my backup"
        },
        "mnemonic": {
          "title": "Your Wallet Mnemonics",
          "caption": "Write down these words and keep them in a safe place",
          "clip": "Copy Mnemonics to Clipboard"
        },
        "store": {
          "title": "Store your mnemonics in a safe place",
          "caption": "You only need to make this backup once no matter how many accounts or transactions you have."
        }
      }
    }
  },
  "welcome": {
    "enroll": {
      "title": "Welcome to the Melis Wallet",
      "caption": "",
      "new": {
        "title": "I do not have a Melis wallet",
        "caption": "I don't have a wallet and want to enroll for one. Enrolling is a very simple process and just takes a few seconds of your time."
      },
      "import": {
        "title": "I have a melis wallet",
        "caption": "I already have a melis wallet and want to pair and import the credentials on this device or recover them from a backup."
      }
    },
    "has-credentials": "It looks like you already have some credentials stored on this device. If you go on from here you may lose them.",
    "pair": {
      "title": "I have the wallet on another device",
      "caption": ""
    },
    "recover": {
      "title": "I have a paper backup",
      "caption": ""
    },
    "import": {
      "title": "I have a list of mnemonics",
      "caption": ""
    }
  },
  "pair": {
    "tabs": {
      "pin": {
        "caption": "Enter PIN",
        "descr": "Enter your current PIN"
      },
      "name": {
        "caption": "Device name",
        "descr": "A name to identify the new device"
      },
      "gen": {
        "caption": "Pair",
        "descr": "Scan QR code on target device"
      }
    },
    "source": {
      "title": "Start pairing on your source device",
      "caption": "Open Melis on your source device go to the wallet settings and from there start the pairing process. Once you have the paring code go to the next step."
    },
    "w": {
      "pin": {
        "title": "Unlock your credentials",
        "caption": "Melis needs to unlock your credentials in order to transfer them to your new device and it needs the PIN. Also at the end of the pairing your new device will have the same PIN."
      },
      "name": {
        "title": "Name your device",
        "caption": "Giving your new device a name will help you remember which is which and manage the devices that have access to your wallet"
      },
      "code": {
        "title": "Pair your device",
        "caption": "On your new device go to the 'I want to pair to an existing device' section at startup. And open the camera on this image"
      }
    },
    "import": {
      "tabs": {
        "qrcode": {
          "caption": "QR Code scan",
          "descr": "Use your camera"
        },
        "source": {
          "caption": "Source Device",
          "descr": "Prepare for pairing"
        },
        "pin": {
          "caption": "PIN",
          "descr": "Your current PIN"
        }
      },
      "title": "Click the button to open camera",
      "caption": "If you have a QR code displayed on your source device open the camera on this device and aim it at the displayed QR code",
      "error": "<b>Error while pairing devices: </b> Something went wrong during the procedure, please try again.",
      "scan-error": "<b>Could not acquire a valid pairing QR-code</b>. Make sure you are pairing with an existing Melis device, not scanning a backup card",
      "pin": {
        "title": "We need your PIN",
        "caption": "Enter the PIN for your account on the OTHER device. It will become the PIN for this device too. You can go and change it in the preferences.",
        "wrong": "Invalid PIN",
        "ph": "PIN..."
      },
      "success": {
        "title": "Pairing complete",
        "caption": "You can now access your wallet from this device"
      },
      "device": {
        "invalid": "Invalid device"
      },
      "data": {
        "ph": "Paste raw data here..."
      }
    }
  },
  "info": {
    "backup": {
      "title": "backup card",
      "caption": "This backup card is used to recover your wallet in the event of a loss of your device or in case the credentials inside your devices are deleted. This card contains all the credentials used to access or recover your wallet and your funds. <b>If you chose to encrypt it then you will also need the passphrase to unlock the backup.</b> If you lose your backup or forget the passphrase your money is gone. There is no way back.",
      "warn": "keep this secret",
      "instructions": "Anyone with access to this backup card can gain access to your wallet transfer your funds and impersonate you in multi signature accounts.",
      "additional": "You can recover the backup using either the photographic recovery using the QR-code or by typing the words in the mnemonics box",
      "mnemo": {
        "title": "mnemonics",
        "caption": "Mnemonics are used for manual recover of a backup in case your device does not have a camera to acquire the QR-code. They hold the same content as the code so although you can write them down or copy to other places they should be considered as important as the code itself."
      }
    }
  },
  "noserver": {
    "title": "Recovery files",
    "caption": "Recovery files can be used into the <b>Melis Recovery Tool</b> to recover your funds in case the server is unavailable.",
    "updated": "Last updated {{when}}."
  },
  "cnfail": {
    "title": "Cannot connect to the Melis network.",
    "caption": "The client failed to connect to the network. It may be down or unreachable.",
    "button": "Recovery mode"
  },
  "sign": {
    "message": {
      "title": "Sign with address",
      "noaddr": "No address available",
      "text": "Text to sign:",
      "with": "With address:",
      "sign": "Sign",
      "dismiss": "Dismiss",
      "findaddr": {
        "title": "Address for signing",
        "caption": "You can use any of your address for signing a message"
      }
    },
    "check": {
      "title": "Check Signature",
      "dismiss": "Dismiss",
      "valid": "The signature is valid.",
      "invalid": "The signature is <b>not</b> valid.",
      "text": "Signed text:",
      "address": "Signing address",
      "signature": "Signature",
      "check": "Check Signature",
      "button": "Verify Signature"
    }
  },
  "cm": {
    "ex": {
      "spendableLimitReached": "{{hours}} hours {{type}} limit exceeded: {{alreadySpent}} already spent, {{amountToSpend}} requested. Limit is: {{limit}} (satoshis)"
    }
  }
};
