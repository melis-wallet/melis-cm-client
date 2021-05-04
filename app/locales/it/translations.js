export default {
  "app.title": "Melis",
  "app.wallet": "wallet",
  "locale": "English",
  "locales": {
    "en": "English",
    "it": "Italiano"
  },
  "errors": {
    "description": "Il campo",
    "inclusion": "{{description}} non è incluso nella lista",
    "exclusion": "{{description}} è riservato",
    "invalid": "{{description}} non è valido",
    "confirmation": "{{description}} non corrisponde a {{on}}",
    "accepted": "{{description}} deve essere accettato",
    "empty": "{{description}} non può essere vuoto",
    "blank": "{{description}} è necessario",
    "present": "{{description}} deve essere omesso",
    "collection": "{{description}} deve essere una collezione",
    "singular": "{{description}} non può essere una collezione",
    "tooLong": "{{description}} è troppo lungo (massimo {{max}} caratteri)",
    "tooShort": "{{description}} è troppo corto (minimo {{min}} charatteri)",
    "before": "{{description}} deve essere prima di {{before}}",
    "after": "{{description}} deve essere dopo {{after}}",
    "wrongDateFormat": "{{description}} deve essere nel formato {{format}}",
    "wrongLength": "{{description}} è della lunghezza sbagliata (deve essere {{is}} caratteri)",
    "notANumber": "{{description}} deve essere un numero",
    "notAnInteger": "{{description}} deve essere un intero",
    "greaterThan": "{{description}} deve essere maggiore di {{gt}}",
    "greaterThanOrEqualTo": "{{description}} deve essere maggiore o uguale a {{gte}}",
    "equalTo": "{{description}} deve essere uguale a {{is}}",
    "lessThan": "{{description}} deve essere inferiore a{{lt}}",
    "lessThanOrEqualTo": "{{description}} deve essere inferiore o uguale a {{lte}}",
    "otherThan": "{{description}} deve essere diverso da {{value}}",
    "odd": "{{description}} deve essere dispari",
    "even": "{{description}} deve essere pari",
    "positive": "{{description}} deve essere positivo",
    "date": "{{description}} deve essere una data valida",
    "email": "{{description}} deve essere un indirizzo email",
    "phone": "{{description}} deve essere un numero di telefono",
    "url": "{{description}} deve essere un url valido"
  },
  "validations": {
    "insfunds": "Fondi insufficienti.",
    "notbitcoin": "Non è un indirizzo valido per la coin",
    "not-coin": "Non è un indirizzo della coin",
    "not-pubid": "Non è un public id Melis",
    "not-pubid-a": "Non è un public id o un alias Melis",
    "duplicate-alias": "Questo alias non è disponibile",
    "not-mnemonic": "Non è un mnemonico valido"
  },
  "generic": {
    "loginfailed": "Accesso Fallito.",
    "disconnected": "disconnesso riconnessione...",
    "not-set": "[ non impostato ]",
    "ok": "Ok",
    "cancel": "Annulla",
    "alert": {
      "title": "Attenzione",
      "caption": "L'operazione che stai effettuando ha delle conseguenze che richeidono una perticlare attenzione."
    }
  },
  "actions": {
    "receive": "Ricevi",
    "send": "Invia"
  },
  "label-picker": {
    "ph": "scegli le etichette di classificazione"
  },
  "coins": {
    "unit": {
      "nocoin": "Nessuna Coin",
      "allcoins": "Tutte le Coin",
      "btc": "Bitcoin",
      "bch": "Bitcoin Cash",
      "abc": "Bitcoin ABC",
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
        "name": "Personale senza server",
        "description": "Conto personale singolo utente senza server",
        "explain": "Questo è un conto personale con una sola firma (la tua). Il server non può limitare le spese o garantire le Transazioni Instantanee."
      },
      "twooftwo": {
        "name": "Personale con server",
        "description": "Conto personale singolo utente con server",
        "explain": "Questo è un conto personale in cui il server può limitare le spese e garantire le Transazioni Istantanee."
      },
      "multisrv": {
        "name": "Multifirma con server",
        "description": "Conto multifirma con firma del server obbligatoria",
        "explain": "Questo conto multifirma richiede la firma del server ed un numero configurabile di altri cofirmatari. Il server è in grado di limitare le spese e garantire Transazioni Istantanee."
      },
      "multi": {
        "name": "Multisignature [+ Server]",
        "description": "Multisignature with Optional Server",
        "explain": "Questo conto multifirma prevede una firma opzionale del server ed un numero configurabile di altri cofirmatari. Il server non può limitare le spese e garantire Transazioni Istantanee."
      },
      "multisimp": {
        "name": "Multifirma senza server",
        "description": "Conto multifirma senza server obbligatorio",
        "explain": "Questo conto multifirma richiede un numero configurabile di firme per compiere operazioni. Il server non puòlimitare le spese o garantire le Transazioni Instantanee."
      },
      "cosigner": {
        "name": "Cofirmatario",
        "description": "Cofirmatario in un conto multifirma",
        "explain": "Da utilizzare quando ci si unisce ad un conto multifirma."
      },
      "unknown": {
        "name": "Unknown Account Name",
        "description": "Unknown Account Description",
        "explain": "Unknown Account Explaination"
      }
    },
    "simple": {
      "plain": {
        "name": "Senza Server",
        "description": "Senza Server",
        "explain": "Un conto senza server non ha costi di rinnovo degli unspent (se la funzionalità è abilitata) ma non offre le funzionalità di protezione aggiuntive."
      },
      "twooftwo": {
        "name": "Con il Server",
        "description": "Con il Server",
        "explain": "Un conto con la firma del server offre la migliore sicurezza ma potrebbe richiedere un piccolo costo."
      }
    }
  },
  "aa": {
    "modal": {
      "title": "Autorizzazioni",
      "pin": {
        "title": "E' necessario inserire il pin",
        "caption": "Per motivi di sicurezza è necessario il tuo pin per autorizzare questa operazione."
      },
      "tfa": {
        "title": "TFA",
        "caption": "Per motivi di sicurezza è necessario il tuo 2fa per autorizzare questa operazione."
      },
      "token": {
        "title": "Abbiamo bisogno il tuo codice d'invito",
        "caption": "Melis è ancora in test. Per questa ragione stiamo invitando persone a testare il nostro prodotto. Se hai ricevuto un codice d'invito inseriscilo qui. In caso contrario puoi richiederne uno tramite il nostro sito web.",
        "label": "Codice d'invito",
        "ph": "Inserisci qui il codice d'invito che hai ricevuto.",
        "error": "Controllando il tuo codice d'invito si è verificato un errore. Il problema è temporaneo ti preghiamo di riprovare tra poco.",
        "invalid": "Spiacenti il tuo codice d'invito non è valido."
      }
    },
    "error": {
      "busy": "Cannot perform authorization now already a challenge in progress.",
      "token-req": "Per registrarsi al servizio occorre un invito. Ma non è stato fornito.",
      "tfa-req": "L'operazione richiede una autenticazione a due fattori. Ma non è stata completata.",
      "tfa-pin-req": "L'operazione richiede l'autenticazione a due fattori oppure il PIN ma non sono stati forniti",
      "invalid-tfa-token": "Il token non è valido"
    }
  },
  "ab": {
    "empty": {
      "title": "La rubrica è vuota",
      "caption": "Utilizza la rubrica per registrare altri utenti Melis o normali indirizzi"
    },
    "nomatch": {
      "title": "La ricerca non ha dato risultati",
      "caption": "Semplifica la ricerca per ottenere più risultati."
    },
    "types": {
      "cm": "Un altro utente Melis",
      "address": "Un indirizzo Coin generico"
    },
    "table": {
      "pubid": "Identità pubblica:",
      "alias": "Alias:",
      "name": "Nome:",
      "profile": "Profilo:"
    },
    "form": {
      "type": {
        "label": "Tipo di contatto",
        "coin": "Coin"
      },
      "name": {
        "label": "Nome",
        "ph": "Inserisci un nome per identificare questo contatto..."
      },
      "alias": {
        "label": "Alias o Identità pubblica",
        "ph": "Cerca un alias o un'identità pubblica"
      },
      "address": {
        "label": "Indirizzo",
        "ph": "Inserisci un indirizzo per questo contatto..."
      },
      "labels": {
        "label": "Etichette"
      },
      "t": {
        "melis": "Altro utente Melis",
        "addr": "Indirizzo Generico"
      }
    },
    "state": {
      "no-contacts": "La rubrica è vuota",
      "no-matches": "Nessun contatto corrisponde alla ricerca",
      "populate": "Puoi gestire la rubrica utilizzando il bottone sottostante"
    },
    "links": {
      "manage": "Gestione della rubrica"
    }
  },
  "account": {
    "secure": "sicuro",
    "lite": "lite",
    "defaults": {
      "name": "Il mio primo conto"
    },
    "actions": {
      "Logout": "esci"
    },
    "selector": {
      "joined": "{{count}}/{{total}} cofirmatari aderiti",
      "joined-s": "{{count}}/{{total}} aderiti"
    },
    "mgmt": {
      "title": "Tutti i conti",
      "caption": "Tutti i conti associati a questo wallet.",
      "secure": {
        "title": "Conti sicuri",
        "caption": "Un conto sicuro è visibile solo sul dispositivo <b>primario</b>."
      }
    },
    "maint": {
      "title": "Operazioni di Manutenzione",
      "caption": "Operazioni di manutenzione avanzate per il tuo conto",
      "lite": {
        "title": "Lite account",
        "caption": "Questo è un account lite. Alcune opzioni e funzioni non sono disponibili sugli account lite, oppure vengono eseguite dalla versione lite del wallet."
      },
      "hide": {
        "title": "Nascondi questo conto",
        "caption": "I conti nascosti scompaiono dal menu su <b>questo</b> dispositivo ma continuano a funzionare normalmente. E' possibile renderli nuovamente visibili in qualunqune momento."
      },
      "secure": {
        "title": "Rendi riservato",
        "caption": "Un conto riservato è visibile solo dal dispositivo <b>primario</b>.",
        "already": "Questo conto è riservato.",
        "warn": "Questo <b>non</b> è il dispositivo primario se imposti questo conto come riservato non sarà più visibile.",
        "prompt": {
          "title": "Conto sicuro",
          "caption": "Questo conto sarà visibile solo dal dispositivo primario."
        },
        "npprompt": {
          "title": "Questo non è il dispositivo primario",
          "caption": "Se si imposta questo conto come sicuro <b>non sarà più accessibile da questo dispositivo. Sarà necessario utilizzare il dispositivo primario per modificare l'impostazione."
        }
      },
      "danger": {
        "title": "Zona pericolosa",
        "caption": "Questo abiliterà operazioni pericolose"
      },
      "delete": {
        "hasbalance": "Questo conto <b>ha un bilancio positivo</b>. Perciò non può essere rimosso ",
        "title": "Cancella conto",
        "caption": "Questa operazione cancellerà il tuo conto. Non può essere annullata.",
        "btn": "Cancella conto",
        "w": {
          "title": "Cancella conto",
          "caption": "Cancellare un conto lo renderà inaccessibile. <b>Sei sicuro di volere cancellare questo conto?</b>"
        }
      },
      "xpub": {
        "title": "Exporta T/XPUB",
        "caption": "",
        "clip": "copia in clipboard"
      }
    },
    "cosigners": {
      "you": "Tu",
      "collect": {
        "title": "Definisci il nome del cofirmatario",
        "caption": "Inserisci un nome di almeno 4 caratteri per identificare il cofirmatario e defisci se la sua firma è obbligatoria o meno"
      },
      "form": {
        "name": {
          "label": "Nome",
          "ph": "Nome per questo cofirmatario..."
        },
        "mname": {
          "label": "Il tuo nome",
          "ph": "Come i cofirmatari vedranno te"
        },
        "mmandatory": "La tua firma è obbligatoria?",
        "fees": "Le commissioni per i pagamenti di questo conto saranno <b>{{fees}}x</b> di quelle di un conto a firma singola."
      },
      "readonly": "In questo schema alcuni cofirmatari non possono firmare"
    },
    "multi": {
      "i-master": {
        "title": "Questo è un conto multifirma",
        "caption": "Invia ai cofirmatari il codice di adesione che compare accanto ai loro nomi ed attendi che aderiscano al conto."
      },
      "i-co": {
        "title": "Questo è un conto multifirma",
        "caption": "Il conto sarà attivo quanto tutti i cofirmatari hanno aderito."
      },
      "status": {
        "cosigners": "Cofirmatari",
        "title": "Conto multifirma",
        "caption": "Questo testo spiega lo stato del conto",
        "server-sig": "Firma del Server",
        "server-mand": "Il Server è obbligatorio",
        "master": "master",
        "mandatory": "necessario",
        "not-joined": "Non ancora aderito",
        "joined": "unito",
        "clip": "Copia il codice di adesione negli appunti",
        "incomplete": "In attesa che i cofirmatari aderiscano",
        "delete": "Cancella questo conto",
        "lite": "Account Lite"
      },
      "join": {
        "code": {
          "label": "Codice di adesione",
          "ph": "Inserisci il codice di adesione"
        },
        "notfound": "Il codice di adesione che hai inserito non è stato trovato.",
        "default-name": "Nuovo conto multifirma"
      }
    },
    "unavailable": {
      "title": "Il conto non è disponibile",
      "caption": "Il conto selezionato non è disponibile"
    },
    "utils": {
      "title": "Utilità",
      "caption": "Utilità varie relative ai tuoi conti Melis",
      "profile": {
        "title": "URL del profilo pubblico",
        "caption": "Puoi usare questo URL per collegare le persone al tuo profilo pubblico di Melis"
      },
      "donate": {
        "title": "Donazioni",
        "caption": "Puoi inviare i visitatori della tua pagina ad un'applicazione dove possono lasciarti una donazione attraverso Melis",
        "explain": "Ecco il codice per inserire il link:"
      },
      "payto": {
        "title": "URL per i pagamenti pubblici",
        "caption": "Ricevi pagamenti o donazioni da qualsiasi altro utente Melis o chiunque abbia un wallet per cryptocurrencies"
      }
    },
    "wizard": {
      "t-coin": {
        "title": "Coin",
        "caption": "Coin",
        "desc": "Scegli la coin"
      },
      "t-single": {
        "title": "Conto Personale",
        "caption": "<b>Il conto è personale</b> Potrai compiere qualsiasi operazione sul conto autonomamente."
      },
      "t-multi": {
        "title": "Conto Multiutente",
        "caption": "<b>Un conto coin avanzato condiviso con altri utenti.</b> I conti condivisi richiedono un numero predefinito di firme da parte dei cofirmatari al fine di autorizzare le operazioni. <i>Durante la definizione del conto deciderai chi sono i cofirmatari e quante sono le firme necessarie."
      },
      "server": {
        "title": "Abilita la protezione del server",
        "caption": "Seleziona se il conto necessita della firma del server."
      },
      "t-with-server": {
        "title": "Il conto richiede la firma del server",
        "caption": "La firma del server puo' gestire politiche di spesa, inoltre sarà possibile effettuare Transazioni Instantanee. I conti con la firma del server sono piu sicuri ma per ragioni tecniche possono avere costi di commissioni leggermente più alti."
      },
      "t-no-server": {
        "title": "Conto senza firma del server",
        "caption": "La protezione del conto è completamente a tuo carico o a carico degli utenti che condividono il conto in base alle regole di firma selezionate."
      },
      "cosigners": {
        "requiredSigsTitle": "Firme obbligatorie",
        "requiredSigsCaption": "Il numero minimo di firme obbligatorie per autorizzare un pagamento.",
        "cosignerInfo": "Dettagli cofirmatario",
        "masterInfo": "Master (tu)"
      },
      "t-type": {
        "caption": "Tipo di conto",
        "desc": "Singolo o multifirma"
      },
      "t-server": {
        "caption": "Server",
        "desc": "Protezione del server"
      },
      "t-name": {
        "caption": "Nome",
        "desc": "Rivedi e dai un nome"
      },
      "t-cosigners": {
        "caption": "Cofirmatari",
        "desc": "Seleziona lo schema e i firmatari"
      },
      "coin": {
        "title": "Coin",
        "caption": "<b>Su quale coin è basato questo account?</b><br/><br/>Account basati su coin diverse non sono interoperabili."
      },
      "error": "La creazione del conto è fallita",
      "error-explain": "Qualcosa non ha funzionato correttamente. Potrebbe essere un problema momentaneo riprova tra poco e se il problema persiste contatta il supporto.",
      "locked": "Il server è bloccato",
      "locked-explain": "Il processo non può essere completato perchè il server è attualmente in esecuzione con alcune funzioni disabilitate. E' uno stato temporaneo e sarà risolto tempestivamente",
      "summary": {
        "warn": "<b>La composizione del conto</b> il numero di firme le soglie e i cofirmatari con firma obbligatoria <b>non possono essere modificati</b> dopo la creazione del conto. Verifica ora che non ci siano errori."
      },
      "j-side": {
        "title": "Aderisci ad un conto multifirma",
        "caption": "Un conto multifirma è condiviso con altri utenti. In base alle regole del conto potrebbe essere necessaria la maggioranza degli utenti per autorizzare i pagamenti."
      },
      "join": {
        "title": "Inserisci il tuo codice d'adesione",
        "caption": "Se hai ricevuto un codice di adesione inseriscilo qui di seguito. Se l'operazione andrà a buon fine il conto comparirà nel menù.",
        "action": "Usa codice d'adesione"
      },
      "name": {
        "title": "Scegli un nome per il tuo conto",
        "caption": "Il nome serve solo a te per indentificare ogni conto"
      },
      "complete": {
        "title": "Fatto!",
        "caption": "Il tuo conto è stato creato.",
        "single": "Il tuo nuovo conto è pronto per l'uso puoi ricevere i pagamenti e una volta che hai fondi effettuarli a tua volta.",
        "multi": "Gli conto multiutente richiedono l'adesione di tutti i cofirmatari prima di poter essere utlizzati. Istruiscili per aderire al conto.",
        "name": "Nome",
        "type": "Tipo"
      },
      "type": {
        "title": "Scegli il tipo di conto",
        "caption": "Il tuo wallet è in grado di gestire diversi tipi di conti: singolo e multiutente. Il conto che stai creando è per il tuo uso personale o dovrà essere condiviso con un altri utenti?"
      },
      "osimple": {
        "title": "Conto Semplice",
        "caption": "Conto predefinito: singolo utente con la firma del server per una maggior sicurezza."
      },
      "oadv": {
        "title": "Conto Avanzato",
        "caption": "Utilizzando questa opzione si potrà creare un conto di qualsiasi tipo"
      },
      "select": {
        "title": "Premi avanti per continuare",
        "caption": ""
      },
      "totalsigs": {
        "title": "Numero totale di utenti",
        "caption": "Seleziona il numero totale degli utenti (compreso te) che hanno poteri di firma per questo conto."
      },
      "reqsigs": {
        "title": "Numero di firme minime",
        "caption": "Seleziona il numero minimo di firme richieste per autorizzare un pagamento. Minimo: 1 Massimo: il numero degli utenti di questo conto."
      },
      "advanced": {
        "title": "Creazione di un conto avanzato",
        "caption": "Personalizza il tuo nuovo conto",
        "name": {
          "label": "Nome",
          "ph": "Inserisci il nome del conto..."
        }
      },
      "simple": {
        "title": "Conto Semplice",
        "caption": "Stai creando un nuovo conto singolo utente con la firma del server per una maggior sicurezza.",
        "name": {
          "label": "Nome",
          "ph": "Inscerisci il nome del nuovo conto..."
        }
      }
    },
    "limits": {
      "no-server": {
        "title": "Il conto non ha la firma del server",
        "caption": "Sebbene il server Melis rispetti i limiti impostati e si rifiuti di creare transazioni che li eccedono questo conto non ha la firma del server e pertanto <b>non è possibile garantire crittograficamente che il limiti siano rispettati.</b>"
      },
      "soft": {
        "title": "Soft Limits",
        "caption": "Per autorizzare un pagamento sopra al limite impostato nei Soft Limits viene richiesta un'autenticazione a due fattori (2FA). Se spendi per un determinato periodo importi maggiori di quelli indicati ti verrà richiesta un'autorizzazione tra quelle che hai scelto nell'autorizzazione a due fattori per consentire la transazione."
      },
      "hard": {
        "title": "Hard Limits",
        "caption": "Non puoi superare in alcun modo gli importi indicati nell'hard limit. Puoi modificare il limite impostato ma un cambiamento di un limite mensile ad esempio avrà bisogno di un mese per diventare attivo."
      },
      "period": "Periodo",
      "treshold": "Soglia ({{unit}})",
      "lastModified": "Ultima modifica {{when}}",
      "daily": "Giornaliero",
      "weekly": "Settimanale",
      "monthly": "Mensile",
      "none": "non impostato",
      "always": "sempre",
      "willchange": "Cambierà {{when}}",
      "no-tfa": "Non ha molta utilità attivare i soft-limits se non c'è attivato nessun meccanismo di <b>autenticazione a due fattori</b>.",
      "set-tfa": "Puoi modificare qui le impostazione dell'autenticazione a due fattori."
    },
    "a": {
      "secure": "imposta come sicuro",
      "unsecure": "imposta come non sicuro",
      "hide-show": "nascondi/mostra"
    }
  },
  "address": {
    "list": {
      "title": "Indirizzi"
    }
  },
  "backup": {
    "needed": {
      "title": "ATTENZIONE: non hai eseguito il backup delle tue credenziali",
      "caption": "Effettua un backup delle credenziali in modo da conservare l'accesso al tuo wallet. <b>In caso di problemi senza un backup potresti perdere i tuoi fondi</b>. Questa operazione devi farla solo una volta e vale per sempre.",
      "action": "Effettua ora il backup dei tuoi mnemonics"
    },
    "nagger": {
      "title": "Ricorda di fare un backup delle tue credenziali",
      "caption": "I tuoi conti hanno del credito, ricordati di verificare di avere un backup valido. <br><b>Se dovessi perdere le credenziali perderai l'accesso a tutti i tuoi fondi, non c'è possibilità di recupero!</b>"
    },
    "check": {
      "action": "Ho un backup. Non mostrare più",
      "title": "Backup Check"
    },
    "wizard": {
      "title": "Credentials Backup"
    },
    "ckw": {
      "intro": {
        "caption": "Perché?",
        "descr": "Check Backup"
      },
      "pin": {
        "caption": "PIN",
        "descr": "Sblocca credenziali"
      },
      "mnemo": {
        "caption": "Backup",
        "descr": "Recupero Backup"
      },
      "qrc": {
        "caption": "Passphrase",
        "descr": "Sblocca Backup"
      }
    },
    "ck": {
      "intro": {
        "title": "Verifica il tuo backup",
        "caption": "Il processo ti guiderà a verificare che il backup in tuo possesso è funzionante"
      },
      "pin": {
        "title": "PIN",
        "caption": "Melis richiede di sbloccare le credenziali per verificare siano le stesse contenute nel backup"
      },
      "mnemo": {
        "title": "Mnemonics",
        "caption": "Inserisci le parole mnemoniche del tuo backup (e premi invio). Se si tratta di un backup criptato verrà richiesta la passphrase per sbloccarlo"
      },
      "or-qr": {
        "title": "Oppure scansiona il codice nella backup card",
        "caption": "Se il tuo dispositivo ha un a fotocamera puoi verificare che il codice sul foglio di backup sia funzionante."
      },
      "cmnemo": {
        "title": "Backup criptato",
        "caption": "Il backup è criptato, è quindi necessaria la passphrase."
      },
      "success": {
        "title": "Successo!",
        "caption": "Il tuo backup è valido."
      },
      "failure": {
        "title": "Verifica fallita!",
        "caption": "Questo backup <b>appare essere valido</b>, ma non corrisponde alle tue credenziali. Qualcosa è andato storto, verifica tutto il possibile e riprova. <b>E' estremamente importante fare un nuovo backup ora!<b>"
      },
      "err": {
        "failed-backup": "Questo backup <b>appare essere valido</b>, ma non corrisponde alle tue credenziali. <b>E' estremamente importante fare un nuovo backup ora!<b>",
        "failed-encrypted": "Se il backup era criptato è possibile che la passphrase sia stata inserita in modo errato. In tal caso, riprova.",
        "failed-check": "Si è verificato un errore e non è stato possibile verificare il  backup. b>E' estremamente importante fare un nuovo backup ora!<b>",
        "pair": "Il codice che stai acquisendo sembra essere un codice di pairing",
        "invalid-scan": "Il codice che stai acquisendo non appare essere un backuop Melis, ma puoi riprovare in caso l'immagine fosse stata acquisita in modo corrotto",
        "invalid-gen": "Il codice sembra essere un backup Melis, ma è stato ricevuto in modo corrotto. Per favore, riprova",
        "scanner": "Si è verificato un error con la fotocamera acquisendo l'immagine"
      }
    }
  },
  "enroll": {
    "state": {
      "idle": "Lavori in corso...",
      "enrolling": "Stai sottoscivendo un Wallet.",
      "done": "Eseguito.",
      "acreate": "Stai creando un conto predefinito.",
      "aselect": "Selezione conto."
    },
    "btn": {
      "summary": "Accedi al tuo wallet"
    },
    "tabs": {
      "backup": {
        "caption": "Backup",
        "descr": "Scrivi i tuoi mnemonics."
      },
      "type": {
        "caption": "Digita",
        "descr": "Seleziona un tipo di conto."
      },
      "pin": {
        "caption": "Pin",
        "descr": "Imposta il tuo PIN."
      },
      "enroll": {
        "caption": "Sottoscrivi",
        "descr": "Hai sottoscritto il tuo conto."
      }
    },
    "tabspanel": {
      "coin": {
        "title": "Coin iniziale",
        "caption": "Seleziona la <b>coin</b> su cui sarà basato il tuo primo account",
        "notice": "Potrai creare ulteriori account basati sulla stessa, o altre coin, più tardi."
      },
      "backup": {
        "title": "Questo dispositivo ha già le credenziali per un wallet",
        "caption": "Se tu sottoscrivi un nuovo wallet perderai le credenziali su questo dispositivo. Se dovrai accedere di nuovo al wallet dovrai utilizzare il backup. Verifica di avere il backup.",
        "btn": "Effettua ora il backup delle credenziali correnti."
      },
      "pin": {
        "title": "Scegli un PIN",
        "caption": "Il PIN permette di accedere in modo semplice e sicuro al tuo wallet da questo dispositivo. Scegli una password semplice o un codice numerico di almeno 4 cifre.",
        "remember": "Accertati di ricordare il PIN sarà necessario per compiere le operazioni importanti.",
        "advanced": "Opzioni avanzate",
        "skip": "Salta la creazione di un conto predefinito"
      },
      "type": {
        "title": "Scegli il tipo del tuo primo conto",
        "caption": "Puoi avere un numero illimitato di conti nel tuo wallet. Ogni conto può essere di tipo diverso."
      }
    },
    "failed": {
      "title": "Sottoscrizione fallita",
      "caption": "Il processo di sottoscrizione è fallito. L'errore restiuito dal server è stato:",
      "startover": "Va bene"
    },
    "locked": {
      "title": "Il server è bloccato",
      "caption": "Il tuo wallet è stato creato ma non siamo riusciti a creare un conto in quanto il server è in esecuzione con funzionalità limitate ti preghiamo di riprovare tra poco il processo riprenderà da questo punto.",
      "startover": "Ricomincia"
    },
    "success": {
      "title": "Sottoscrizione completata",
      "caption": "Ora puoi accedere al tuo wallet ti consigliamo come prima cosa di fare un backup. Puoi decidere di fare il backup in un secondo momento ma ricordati di farlo alla tua prima transazione in ingresso.",
      "warning": "Se dimentichi il codice PIN o perdi le credenziali e non disponi di un backup perderai l'accesso al wallet ed a tutte le tue cryptovalute.",
      "backup": "Fai il backup del tuo wallet",
      "skip": "Salta il backup e continua"
    },
    "walletok": {
      "title": "Il tuo wallet è stato creato",
      "caption": "Alla sottoscrizione si è scelto di non creare un accont. A questo punto è necessario creare il tuo primo conto.",
      "createacct": "Crea un nuovo conto"
    },
    "complete": {
      "title": "Attenzione: importante",
      "caption": "Le coin sono valute interisecamente crittografiche. Se le credenziali del wallet vengono smarrite o sottratte si possono verificare situazioni in cui sia impossibile recuperare i fondi. <b>Esercita la dovuta diligenza, fai i backup e conservali in un luogo sicuro</b>."
    }
  },
  "dash": {
    "account": {
      "notifications": "NOTIFICHE",
      "pending": "PAGAMENTI IN SOSPESO"
    },
    "multi": {
      "joinwait": "In attesa che i cofirmatari aderiscano...",
      "joined": "{{count}}/{{total}} cofirmatari aderenti"
    }
  },
  "license": {
    "act": {
      "reject": "Rifiuta la licenza",
      "accept": "Accetta",
      "reset": "Rivedi la licenza"
    },
    "modal": {
      "title": "Ti preghiamo di rivedere la licenza"
    },
    "scroll-hint": "(E' necessario scorrere al termine del testo per accettare la licenza)"
  },
  "mm": {
    "entries": {
      "dashboard": "Riepilogo",
      "summary": "Sommario",
      "account": "Conto",
      "send": "Invia",
      "receive": "Ricevi",
      "history": "Storia",
      "ab": "Rubrica",
      "prefs": "Preferenze"
    }
  },
  "netstatus": {
    "mainDisconnection": {
      "title": "Connessione al server persa",
      "text": "Riconnessione automatica in pochi secondi..."
    },
    "state": {
      "ok": {
        "label": "OK",
        "title": "Connesso",
        "text": "Il client è connesso al server."
      },
      "busy": {
        "label": "OCCUPATO",
        "title": "In connessione...",
        "text": "Connessione stabilita"
      },
      "dc": {
        "label": "DC",
        "title": "Il server non è connesso",
        "text": "Il Client ha perso la connessione al server"
      }
    }
  },
  "newaddr": {
    "a": {
      "alternate": "Altro formato",
      "renew": "Ottieni un nuovo indirizzo",
      "make-active": "Crea una richiesta di pagamento",
      "clip": "Copia negli appunti",
      "release": "Annulla questa richiesta",
      "leave": "Ricorda e chiudi",
      "addr-list": "Lista Indirizzi"
    },
    "empty": {
      "info": "[ nessuna impostazione ]",
      "amount": "[ richiedi una somma specifica ]"
    },
    "generated": {
      "title": "Il tuo indirizzo",
      "caption": "Esegui la scansione del codice QR per ricevere un pagamento opppure copia e incolla manualmente l'indirizzo seguente"
    },
    "generate": {
      "title": "Genera un nuovo indirizzo",
      "caption": "Inserisci una descrizione da associare a questo indirizzo da aggiungere alle transazioni in ingresso"
    },
    "current": {
      "title": "Il tuo indirizzo di pagamento",
      "caption": "Questo indirizzo è usato per ricevere un pagamento. E' meglio utilizzare un indirizzo diverso per ogni pagamento in modo che l'indirizzo cambierà ogni volta che si effettuerà un pagamento.",
      "time": "Indirizzo generato il <b>{{when}}</b>."
    },
    "active": {
      "title": "Richiesta di pagamento",
      "caption": "Questo indirizzo sarà accantonato per una specifica richiesta di pagamento. Quando il pagamento sarà effettuato le informazioni inserite qui saranno associate al pagamento.",
      "type": {
        "bitcoin": "Indirizzo coin",
        "melis": "Melis URL"
      },
      "default-ph": "Richiesta di pagamento"
    },
    "form": {
      "more": "Più opzioni",
      "info": {
        "label": "Info",
        "ph": "Inserisci le informazioni su questo indirizzo..."
      },
      "labels": {
        "label": "Etichette"
      },
      "amount": {
        "label": "Importo",
        "ph": "Inserisci un importo da richiedere in questo indirizzo..."
      }
    },
    "gen-error": "Si è verificato un errore con il server durante l'operazione. Riprova più tardi.",
    "noresource-error": "Hai già troppe richieste di pagamento inutilizzate, annullane qualcuna, oppure contattaci se hai esigenza di superare questi limiti.",
    "nocurrent": "Nessun indirizzo corrente",
    "type": {
      "generic": "Indirizzo generico",
      "request": "Richiesta di pagamento"
    },
    "txs": {
      "label": "Transazioni ricevute",
      "none": "Nessuna",
      "chain": "Chain",
      "hdindex": "HD Index",
      "table": {
        "txs": "TXs",
        "amount": "amount",
        "address": "address",
        "date": "data"
      }
    }
  },
  "notif": {
    "you": "Tu",
    "tx": {
      "sent": "Il conto ha appena inviato {{amount}} {{unit}} con successo",
      "received": "Il conto ha ricevuto {{amount}} {{unit}}"
    },
    "ptx": {
      "proposed": "{{source}} ha proposto un pagamento di {{amount}} {{unit}}",
      "has-approved": "{{source}} ha approvato un pagamento in sospeso",
      "has-contributed": "{{source}} ha ccontribuito ad un pagamento in sospeso"
    },
    "evt": {
      "has-joined": "<b>{{subject}}</b> ha aderito con successo al conto ''<span class='text-warning'>{{account}}</span>' {{time}}",
      "wall": "{{text}}",
      "wall-title": "Notifica dal servizio"
    }
  },
  "paysend": {
    "tx-done": "Transazione completata con successo.",
    "tx-success": "Transazione inviata con successo.",
    "sources": {
      "auto": "Selezione automatica degli input"
    },
    "remainder": {
      "auto": "Gestisci automaticamente il resto"
    },
    "fees": {
      "auto": "Imposta automaticamente le fees"
    },
    "funds": {
      "title": "Fondi non confermati",
      "caption": "Hai dei fondi non confermati questi non sono momentaneamente disponibili. Saranno a tua disposizione tra qualche minuto.",
      "unconfirmed": "non confermati",
      "available": "disponibili"
    },
    "no-coins": {
      "title": "non hai fondi",
      "caption": "Questo conto non ha fondi per cui non puoi inviare ancora nulla."
    },
    "prompts": {
      "prepare": "Prepara un pagamento.",
      "sign": "Approva un pagamento",
      "cancel": "Annulla un pagamento"
    },
    "err": {
      "occurred": "Si è verificato un errore preparando la transazione: {{error}}",
      "prepare-fail": "Impossibile preparare la transazione",
      "no-funds": "Fondi insufficienti.",
      "addr-dup": "Questo indirizzo è gia parte di questa transazione."
    },
    "success": "Successo!",
    "tx-signed": "Il pagamento è stato approvato.",
    "tx": {
      "failv": {
        "title": "La transazione fallisce la validazione",
        "caption": "Sebbene le transazioni siano preparate dal server il client Melis ne verifica la correttezza. Quella proposta ha fallito questa verifica. Si tratta probabilmente solo di un bug ma non è sicuro continuare."
      },
      "review": {
        "title": "Rivedi il pagamento",
        "caption": "Ricorda che i pagamenti sono definitivi e non possono essere annullati"
      },
      "review-onemulti": {
        "title": "Questo pagamento richiede una sola autorizzazione",
        "caption": "Questo è un conto multifirma ma questa transazione richiede solo una firma. Puoi firmare ora ed il pagamento sarà confermato oppure puoi lasciare che venga firmata da un cofirmatario (oppure tu stesso) in un secondo momento."
      },
      "review-multi": {
        "title": "Questa proposta di pagamento richiede diverse firme",
        "caption": "Hai bisogno di alcuni cofirmatari per autorizzare questo pagamento. Puoi iniziare ad approvarlo oppure attendere che venga autorizzato dai tuoi cofirmatari (oppure tu stesso) in un secondo momento."
      },
      "disc": {
        "prompt": "Scrivi un messaggio ai tuoi cofirmatari"
      },
      "info": {
        "sigs-req": "Firme richieste",
        "cosig": "Cofirmatari",
        "mandatory": "La tua è necessaria",
        "fees": "Commissioni:",
        "total": "Totale: ({{unit}})"
      },
      "a": {
        "cancel": "Annulla questo pagamento",
        "propose": "Proponi questo pagamento",
        "confirm": "Proponi ed approva questo pagamento",
        "approve": "Approva questo pagamento"
      }
    },
    "head": {
      "title": "Invia denaro",
      "caption": "Inserisci l'importo e il destinatario del pagamento"
    },
    "sum": {
      "sources": "Inputs",
      "dsts": "Destinazioni",
      "remainder": "Resto (inc fees)",
      "fees": "Fees"
    },
    "form": {
      "a": {
        "confirm": "Conferma Transazione",
        "discard": "Cancella Transazione",
        "recpconf": "Conferma Destinatario",
        "recpdisc": "Annulla Destinatario",
        "recpadd": "Aggiungi Destinatario"
      },
      "acc": {
        "sources": "Inputs",
        "destinations": "Destinazioni",
        "remainder": "Resto",
        "options": "Opzioni"
      },
      "insuff-funds": "Fondi insufficienti.",
      "not-bitcoin": "Non è un indirizzo della coin.",
      "entire-balance": "Tutti i fondi",
      "entire-balance-r": "Tutti i fondi restanti",
      "entire-sources": "Tutti gli input",
      "entire-sources-r": "Tutti gli input restanti",
      "more": "Aggiungi ulteriori informazioni",
      "scan": "Acquisisci un indirizzo",
      "ab": "Scegli un indirizzo dalla rubrica",
      "clipboard": "Incolla un indirizzo dagli appunti",
      "type": "Tipo di destinatario",
      "recipient": {
        "label": "Indirizzo destinatario",
        "ph": "Inserisci un indirizzo del destinatario..."
      },
      "amount": {
        "label": "Importo",
        "ph": "Inserisci l'importo da inviare..."
      },
      "currency": {
        "label": "Valuta"
      },
      "labels": {
        "label": "Etichette"
      },
      "info": {
        "label": "Informazioni",
        "ph": "Queste informazioni verranno memorizzate per un tuo riferimento..."
      },
      "memo": {
        "label": "Memo",
        "ph": "Queste informazioni verranno mandate al ricevente, se possibile."
      },
      "pubid": {
        "label": "Conto Melis",
        "ph": "Cerca un alias o ID Pubblica"
      },
      "account": {
        "label": "I tuoi conti",
        "ph": "Seleziona un conto"
      },
      "unc": "Unconfirmed",
      "rbf": "RBF",
      "fees": "Commissioni",
      "feesperbyte": "Commissioni per byte: (satoshi, {{unit}})",
      "fees-provider": "Ottenute da {{provider}}",
      "feesrefresh": "Aggiorna",
      "feesnr": "Stima non disponibile"
    }
  },
  "prefs": {
    "alias": {
      "is": "Il tuo alias è:",
      "not-set": "Il tuo alias non è stato impostato",
      "change": "Definisci un alias",
      "ableto": "Potrai impostare l'alias di questo conto quando avrai almeno {{amount}} nel tuo wallet.",
      "unableto": "You don't meet the criteria for changing the alias yet",
      "once": "L'alias può essere modificato <b>solo</b> una volta",
      "taken": "Questo alias è già in uso",
      "ph": "Scegli un nuovo alias",
      "button": "Sì modifica il mio alias",
      "not-ready": "... sto ottenendo informazioni ...",
      "already-def": "Il tuo alias è stato impostato. Gli Alias non possono essere modificati in quanto ti identificano in modo univoco nel sistema."
    },
    "pin": {
      "changed": "Il Pin è stato modificato con successo",
      "failure": "Il Pin non è stato modificato",
      "button": "Modifica il pin"
    },
    "profile": {
      "identity": "Identità pubblica: ",
      "alias": "Alias: ",
      "name": "Nome: ",
      "address": "Indirizzo: ",
      "profile": "Profilo: "
    },
    "tfa": {
      "title": "Autenticazione a due fattori",
      "caption": "Utilizza un secondo dispositivo per autorizzare le spese sopra i limiti e aumentare la sicurezza del tuo conto."
    }
  },
  "public": {
    "login": {
      "prompt": "Acccedi"
    },
    "payto": {
      "app": "PAGA A",
      "caption": "Invia coin <br>facilmente<br> ad un altro conto Melis",
      "total": "Totale ({{unit}}):",
      "showcode": "Mostra l'indirizzo di pagamento",
      "error": {
        "noaddr": "Si è verificato un errore generando l'indirizzo di pagamento . <b>Si prega di riprovare più tardi.</b>"
      },
      "amount": {
        "ph": "Inserisci l'importo da inviare."
      },
      "note": {
        "title": "Inserisci una nota per il destinatario.",
        "not-set": "[ clicca per cambiare ]"
      },
      "scan": {
        "title": "Acquisisci questo codice",
        "caption": "Direct your wallet to this barcode and scan the address it contains. Then make your payment to it."
      },
      "sign": {
        "title": "Accedi at tuo wallet",
        "caption": "In questo dispositivo ci sono le tue credenziali Melis salvate. Puoi accedere ora ed effettuare rapidamente il pagamento."
      },
      "curr": {
        "enter": "Inserisci il valore in valuta"
      }
    },
    "join": {
      "app": "ADERISCI",
      "caption": "Invia coin <br>facilmente<br> ad un conto Melis",
      "explain": {
        "title": "Ti è stato chiesto di aderire ad un conto condiviso",
        "caption": "Accedi al tuo wallet per creare automaticamente un nuovo conto multiutente con l'utente che ti ha dato il codice d'adesione"
      },
      "enroll": {
        "pin": {
          "title": "Inserisci il PIN",
          "caption": "odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolore"
        },
        "no-creds": {
          "title": "Non sembra che hai le credenziali su questo dispositivo.",
          "caption": "Se hai già un wallet Melis accedi a questo url dal dispositivo che usi abitualmente. Altrimenti apri il tuo wallet e inserisci il codice d'adesione manualmente"
        },
        "button": "Sottoscrivi il Wallet"
      },
      "success": "Hai aderito al conto con successo",
      "error": "Si è verificato un errore durante l'adesione. Riprova più tardi",
      "not-found": "Si è verificato un errore durante l'adesione. Questo codice d'adesione non è stato trovato."
    },
    "profile": {
      "app": "PROFILO",
      "caption": "Invia coin <br>facilmente<br>ad un conto Melis",
      "no-profile": "questo conto esiste ma non ha rilasciato nessun profilo pubblico."
    },
    "error": {
      "no-tx": {
        "title": "Questa transazione non è disponibile",
        "caption": "La transazione richiesta non è stata trovata."
      }
    }
  },
  "qr": {
    "scan": {
      "errors": {
        "media-error": "Si è verificato un errore accedendo alla videocamera. Puoi provare un un browser differente oppure con la nostra applicazione nativa.",
        "no-um": "<b>Questo browser o la piattaforma non supporta i meccanismi che usiamo per accedere alla videocamera.</b> Puoi provare un un browser differente oppure con la nostra applicazione nativa.",
        "no-perms": "<b>Melis non ha potuto accedere alla videcamera per acquisire un'immagine.</b> Verifica di avere fornito i permessi necessari. Se così fosse potresti avere una videocamera o una piattaforma non compatibile"
      },
      "accept": "ok",
      "dismiss": "Respinto",
      "scan": "Scan",
      "upload": "Upload"
    }
  },
  "qrupload": {
    "action": {
      "drag": "Trascina un immagie di un codice QR per acquisirlo",
      "valid": "Deposita l'immagine in questo riquadro",
      "invalid": "Formato non supporttato"
    },
    "btn": {
      "cancel": "Cancella indirizzo",
      "ok": "Conferma indirizzo"
    }
  },
  "quicksend": {
    "title": "Paga da uno dei tuoi conti",
    "caption": "Dato che sei un utente Melis puoi completare il pagamento con uno dei tuoi conti.",
    "account": "Conto attivo",
    "to": "A:",
    "balance": "Bilancio:",
    "available": "Disponibile:",
    "success": "Operazione completata con successo.",
    "error": {
      "addr": "Impossibile ottenere un indirizzo per il destinatario",
      "pay": "Impossibile completare il pagamento"
    }
  },
  "recover": {
    "import": {
      "title": "Acquisisci il tuo backup",
      "caption": "Punta la telecamera al centro della tua backup card sul codice QR e clicca qui di seguito.",
      "wrongsig": {
        "title": "Il tuo backup non è valido",
        "caption": "Abbiamo provato a recuperare questo backup ma le credenziali contenute sono state rifiutate dal server.",
        "warn": "La causa più probabile è che la passphrase non è corretta. Verifica di nuovo e riprova"
      },
      "success": {
        "title": "Il tuo backup è stato importato",
        "caption": "Ora puoi accedere ai tuoi conti da questo dispositivo"
      },
      "passphrase": {
        "title": "Il tuo backup è protetto da una passphrase",
        "caption": "Quando hai creato quersto backup hai deciso di proteggerlo con una passphrase. Ora devi utilizzare la passphrase per importarlo.",
        "ph": "Inserisci la passphrase"
      },
      "setpin": {
        "title": "Scegli un nuvo PIN per questo dispositivo",
        "caption": "Proteggi questo dispositivo con un semplice PIN per sicurezza e accesso rapido."
      },
      "qrcode": {
        "caption": "Acquisisci",
        "descr": "Acquisisci questo backup"
      },
      "pass": {
        "caption": "Passphrase",
        "descr": "Inserisci la passphrase"
      },
      "pin": {
        "caption": "PIN",
        "descr": "Imposta un nuovo PIN"
      }
    }
  },
  "stream": {
    "warning": {
      "skew": "L'orologio di questo dispositivo discorda con il server. Alcune informazioni di tempo mostrate potrebbero essere non corrette."
    },
    "helper": {
      "ptx": {
        "title": "",
        "caption": "creato da: {{by}}"
      },
      "tx": {
        "title": "",
        "caption": ""
      },
      "address": {
        "title": "Pagamento richiesto"
      }
    },
    "txm": {
      "has-contributed": "Ha contribuito a questa",
      "has-signed": "Ha firmato questa",
      "has-approved": "Ha approvato questa",
      "ptx": "proposta di pagamento"
    },
    "hwm": {
      "new-events": {
        "one": "C'è un <b>nuovo evento</b>.",
        "other": "Ci sono <b>{{count}} nuovi eventi</b>."
      },
      "show": "Mostra.",
      "outdated": {
        "title": "Ci potrebbe essere una nuova versione",
        "caption": "Potrebbe essere disponibile una nuova versione di questa applicazione. A seconda della piattaforma puoi controllare se sono disponibili update, o visitare il sito."
      }
    },
    "evt": {
      "wall": "Notifica dal servizio",
      "has-joined": "<b>{{subject}}</b> ha aderito con successo al conto ''<span class='text-warning'>{{account}}</span>' {{time}}",
      "tfad": {
        "title": "E' stato richiesto il reset dell'autenticazione a due fattori!",
        "caption": "E' stata richiesta la procedura di cancellazione di tutti i dispositivi di autenticazione di secondo fattore.<b>Questa procedura ha serie implicazioni di sicurezza.</b>",
        "expire": "Se non intervieni in qualche modo, i dispositivi di seconda autenticazione verranno completamente disattivati <b>{{time}}.</b>",
        "canceled": "La richiesta è stata annullata"
      },
      "tfad-cancel": {
        "title": "La precedente richiesta di reset dell'autenticazione è stata annullata",
        "caption": "La precedente richiesta è stata annullata."
      },
      "devdel": {
        "title": "Un dispositivo è stato cancellato dal wallet",
        "caption": "Il dispostivo '<b>{{label}}</b>' è stato disassociato dal wallet <b>{{time}}</b> e non potrà più accedervi senza reinserire le credenziali."
      },
      "newd": {
        "title": "E' stato associato un nuovo dispositivo",
        "caption": "Il dispositivo '<b>{{label}}</b>' è stato associato a questo wallet <b>{{time}}</b>."
      },
      "newp": {
        "title": "Il dispositivo primario è cambiato",
        "caption": "Il dispositivo '<b>{{label}}</b>' è diventato il dispositivo primario <b>{{time}}</b>."
      },
      "newp-f": {
        "title": "Il dispositivo primario sta per cambiare",
        "caption": "Il dispositivo '<b>{{label}}</b>' diventerà il primario <b>{{time}}</b>."
      },
      "newp-s": {
        "title": "Il dispositivo primario è cambiato",
        "caption": "Questo dispositivo ('<b>{{label}}</b>') è diventato il dispositivo primario <b>{{time}}</b>."
      },
      "newp-sf": {
        "title": "Il dispositivo primario sta per cambiare",
        "caption": "Questo dispositivo ('<b>{{label}}</b>') diventerà il primario <b>{{time}}</b>."
      }
    },
    "ph": {
      "started": "Il tuo conto è pronto!",
      "welcome": "Questa pagina contiene una lista delle attività del tuo conto. Scopri le altre sezioni nel menù di sinistra.",
      "address": "Questo è l'indirizzo per ricevere i tuoi primi coin:"
    },
    "tx": {
      "fees": "commissioni",
      "bump": "Alza le commissioni",
      "rbf": "RBF",
      "invalidated": "Questa transazione è stata sostituita ed invalidata.",
      "sent": "Transazione inviata con successo {{time}}",
      "received": "Transazione ricevuta {{time}}",
      "amount": "Importo: ",
      "to": "a: ",
      "received-ad": "All'indirizzo:",
      "orig-currency": "(era {{amount}}{{unit}} - {{when}})",
      "hash": "TxID",
      "a": {
        "ok": "Ok"
      }
    },
    "ptx": {
      "details": "Dettagli",
      "created": "Proposta di pagamento creata da <b>{{creator}}</b> {{time}}.",
      "rotation": "Rotazione degli input unspent creata da <b>{{creator}}</b> {{time}}.",
      "respent": "La transazione è stata automaticamente annullata perchè un'altra ha utilizzato gli stessi fondi",
      "feebump": "Questa è una proposta di aumento delle commissioni. Se confermata, questa transazione rimpiazzerà una transazione con commissioni più basse.",
      "canceled": "La transazione è stata annullata.",
      "recipients": "Destinatari:",
      "multiple": "Destinatari multipli",
      "amount": "Importo: ",
      "fees": "Commissioni:",
      "sigs-req": "Firme richieste",
      "cosigners-no": "{{count}} cofirmatari",
      "is-mandatory": "La tua è obbligatoria",
      "chat-prompt": "Invia un messaggio ai tuoi cofirmatari",
      "a": {
        "approve": "Approva questo pagamento",
        "cancel": "Annulla questo pagamento",
        "reissue": "Riemetti questo pagamento"
      }
    },
    "addr": {
      "generated": "Richiesta di pagamento generata <b>{{when}}</b>",
      "used-in": {
        "one": "Usato in una tranzazione.",
        "other": "Usato in <b>{{count}}</b> transazioni."
      },
      "see-it": "Guarda.",
      "a": {
        "cancel": "Annulla questa richiesta."
      }
    }
  },
  "ticker": {
    "history": {
      "d": "ULTIME 24H",
      "m": "ULTIMI 30GG"
    }
  },
  "tfa": {
    "recovery": {
      "action": "Aiuto, ho perso tutti i miei dispositivi!",
      "title": "Recupero dell'autenticazione a due fattori",
      "caption": "Se hai perso il controllo di <b>tutti</b> i tuoi dispositivi di autenticazione, puoi inizare la procedura di recupero. <b>La proceudra disattiverà tutti i tuoi dispositivi di autenticazione in un mese da ora</b>. per ragioni di sicurezza, non c'è alcun modo di accelerare il processo",
      "done": {
        "title": "La tua richiesta è stata acquisita",
        "caption": "Tutti i tuoi dispositivi verranno disattivati tra un mese. <b>Nota che, usando uno qualunque dei dispositivi prima di allora, si disattiverà il processo di recupero.</b>"
      },
      "error": {
        "title": "Si è verificato un errore",
        "caption": "Si è verificato un errore registrando la richiesta. Puoi riprovare più tardi."
      }
    },
    "actions": {
      "token-sent": "Token Inviato.",
      "enable": "Abilita",
      "enroll": "Aggiungi",
      "error": "Si è verificare un errore"
    },
    "devices": {
      "email": "Email",
      "sms": "SMS",
      "xmpp": "Jabber/XMPP",
      "telegram": "Telegram",
      "matrix": "Matrix",
      "rfc6238": "Authenticator Device",
      "regtest": "Regtest",
      "unknown": "Dispositivo sconosciuto"
    },
    "state": {
      "title": "Autenticazione a due fattori",
      "caption": "Attiva almeno una TFA per rendere sicuro il tuo wallet",
      "disabled": "L'autenticazione a due fattori è disabilitata",
      "complete": {
        "title": "Dispositivi attivi"
      },
      "incomplete": {
        "title": "Completa la procedura di enroll della autenticazione a due fattori",
        "caption": "Fornisci il codice per completare la procedura di creazione del dispositivo. Il meccanismo di autenticazione sarà attivo quando la procedura è terminata."
      },
      "expire": "Scadrà {{when}}"
    },
    "types": {
      "email": "Email",
      "sms": "SMS",
      "xmpp": "XMPP",
      "telegram": "Telegram",
      "matrix": "Matrix",
      "rfc6238": "App di Autenticazione",
      "u2f": "U2F key",
      "regtest": "Regtest"
    },
    "token": {
      "title": "Invia Token",
      "caption": "Un codice numerico verrà inviato al dispositivo selezionato. In caso di mancato ricevimento è possibile inviarlo nuovamente ma soltanto l'ultimo codice inviato verrà considerato valido",
      "button": "invia",
      "form": {
        "token": {
          "label": "Token",
          "ph": "Inserisci il token."
        }
      }
    },
    "email": {
      "title": "Email",
      "caption": "Inserisci un indirizzo email al quale inviare il codice di autorizzazione",
      "invalid": "Non è un indirizzo email valido",
      "form": {
        "email": {
          "label": "Email",
          "ph": "Inserisci un indirizzo email"
        }
      }
    },
    "telegram": {
      "title": "Telegram",
      "caption": "Inserisci l'identificatore di un utente Telegram dove ricevere i codici di autorizzazione",
      "invalid": "Non è uno username Telegram valido",
      "bot": "Manda un messaggio al bot Telegram:",
      "code": "contenente il codice seguente:",
      "explain": "Quindi inserisci qui il codice che il bot ti risponde:",
      "form": {
        "address": {
          "label": "Username",
          "ph": "@telegram_username"
        }
      }
    },
    "matrix": {
      "title": "Matrix",
      "caption": "Inserisci l'identificatore di un utente Matrix dove ricevere i codici di autorizzazione",
      "invalid": "Non è uno username Matix valido",
      "bot": "Manda un messaggio al bot Matrix:",
      "code": "contenente il codice seguente:",
      "explain": "Quindi inserisci qui il codice che il bot ti risponde:",
      "form": {
        "address": {
          "label": "Username",
          "ph": "@matrix_username"
        }
      }
    },
    "sms": {
      "title": "SMS",
      "caption": "Inserisci un numero di telefono mobile al quale inviare il codice di autorizzazione",
      "invalid": "Non è un numero valido",
      "form": {
        "sms": {
          "label": "SMS",
          "ph": "+CC AAA NNNNNNN"
        }
      }
    },
    "xmpp": {
      "title": "XMPP/Jabber",
      "caption": "Puoi utilizzare Jabber/Gtalk per ottenere un codice di autenticazione",
      "invalid": "Non è un indirizzo xmpp/jabber valido",
      "form": {
        "address": {
          "label": "Indirizzo XMPP",
          "ph": "Inserisci un indirizzo XMPP"
        }
      }
    },
    "rfc6238": {
      "title": "Applicazione Authenticator",
      "caption": "Abilita un dispositivo TOTP come Google Auth o Authy",
      "explain": "Scaansiona questo codice QR code con il tuo dispositivo e fornisci il codice qui di seguito:"
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
      "label": "Il tuo PIN",
      "wrong": "PIN errato",
      "left": "ancora {{count}} tentativi",
      "ph": "Inserisci il tuo PIN",
      "last-attempt": "Ultimo tentativo!",
      "nocreds": {
        "title": "Credenziali assenti sul dispositivo",
        "caption": "Per motivi di sicurezza il dispositivo è stato invalidato e le credenziali rimosse."
      }
    }
  },
  "toasts": {
    "stream": {
      "urgent": {
        "one": "Il conto '<b>{{name}}</b>' ha un nuovo evento che potrebbe richiedere la tua attenzione.",
        "other": "Il conto '<b>{{name}}</b>' ha {{count}} nuovi eventi <b>importanti</b>."
      },
      "entries": {
        "one": "Il conto '<b>{{name}}</b>' ha nuovi eventi.",
        "other": "Il conto '<b>{{name}}</b>' ha {{count}} nuovi eventi."
      }
    },
    "ptx": {
      "cosigner": "Un cofirmatario",
      "newtx": "{{owner}} ha proposto un nuovo pagamento per il conto: {{account}}",
      "newsig": "{{signer}} ha autorizzato un pagamento sul conto: {{account}}"
    }
  },
  "tx": {
    "you": "Tu",
    "you-s": "te",
    "fees": {
      "verylow": "Molto Basse",
      "low": "Basse",
      "normal": "Normali",
      "high": "Alte",
      "veryhigh": "Molto Alte"
    },
    "list": {
      "title": "Transazioni",
      "from": "A partire da:",
      "no-results": "Non ci sono transazioni su questo conto"
    },
    "detail": {
      "rbf": "RBF",
      "moreinfo": "Altre Informazioni",
      "to": "A",
      "fees": "Commissioni",
      "info": "Note",
      "labels": "Etichette",
      "amount": "Impoorto",
      "hash": "TxID",
      "address": "All'indirizzo",
      "received-ad": "Sull'indirizzo",
      "orig-currency": "(in origine {{amount}}{{unit}} - {{when}})",
      "ptx": {
        "sigs": "Firme",
        "cosigners-no": "{{count}} cofirmatari"
      }
    },
    "discussion": {
      "has-approved": "ha approvato questo pagamento.",
      "no-messages": "Non ci sono messaggi in questa conversazione...",
      "enter": "Inserisci il tuo messaggio"
    },
    "signers": {
      "not-signed": "non firmato"
    },
    "txs": {
      "title": "Hai delle proposte di pagamento che richiedono attenzione o un intervento",
      "caption": "Ci sono proposte di pagamento in sospeso che richiedono la tua firma o quella di un cofirmatario per poter essere eseguite. Sono presentate qui per convenienza."
    },
    "notxs": {
      "title": "Non ci sono proposte di pagamento in sospeso",
      "caption": "Tutte le proposte di pagamento sono state pubblicate e approvate."
    },
    "prepared": {
      "to": "A:",
      "state": "Stato:",
      "recipients": "Destinatari:",
      "created": "Proposta di pagamento creata da <b>{{creator}}</b> {{time}}.",
      "amount": "Importo:",
      "signedby": "Firmato da:",
      "discussion": "Conversazione:",
      "createdby": "Creato da:",
      "signatures": "Firme:",
      "multiple": "Multiplo",
      "notsigned": "Non firmato",
      "approve": "Approva",
      "owner": "Proprietario",
      "cancancel": "Puoi annullare questo pagamento",
      "notapproved": {
        "title": "Questa transazione è in attesa della tua autorizzazione.",
        "caption": "Questo pagamento è stato proposto da questo conto ma mancano una o più autorizzazioni tra cui la tua. Rivedi la proposta qui di seguito"
      },
      "approved": {
        "title": "Hai già firmato questo pagamento",
        "caption": "Hai autorizzato questo pagamento ma è ancora in sospeso in quanto mancano le altre firme per autorizzarlo."
      },
      "a": {
        "approve": "Approva questo pagamento",
        "cancel": "Annulla questo pagamento"
      }
    }
  },
  "urgent": {
    "tx": {
      "title": "C'è qualcosa che potrebbe richiedere la tua attenzione.",
      "caption": "Una proposta di pagamento attende una tua azione. I dettagli sono qui di seguito.",
      "link": "Più dettagli qui."
    }
  },
  "view": {
    "details": ": Dettagli.",
    "side": {
      "nav": {
        "history": "Storia",
        "addresses": "Indirizzi",
        "unspents": "Unspents"
      },
      "wallet": {
        "title": "Dettagli del Wallet",
        "caption": "Qui puoi trovare i dettagli del tuo wallet"
      },
      "account": {
        "title": "Dettagli del conto",
        "caption": "Qui puoi trovare i dettagli del tuo conto"
      },
      "backup": {
        "status": "Stato del backup"
      },
      "movements": {
        "title": "Spese",
        "day": "Oggi:",
        "week": "Questa settimana:",
        "month": "Questo mese:"
      },
      "balance": {
        "title": "Bilancio",
        "caption": "Bilancio dettagliato",
        "available": "Disponibile",
        "reserved": "Riservato",
        "unconfirmed": "Non confermato",
        "unmature": "Unmature"
      },
      "multi": {
        "title": "Multifirma",
        "alljoin": "Tutti i cofirmatari hanno aderito.",
        "joined": "Cofirmatari aderenti",
        "joinwait": "In attesa che i cofirmatari aderiscano",
        "fees": "Le commissioni per i pagamenti da questo conto sono approssimatamente <span class='label'>{{fees}}x</span> rispetto ad un conto ad unica firma"
      }
    },
    "tabs": {
      "preferences": "Preferenze",
      "coins": "Coins",
      "vitals": "Cofirmatari",
      "history": "Storia",
      "security": "Sicurezza",
      "maintenance": "Manutenzione",
      "utilities": "Utilità",
      "limits": "Limiti di spesa",
      "devices": "Dispositivi",
      "accounts": "Conti",
      "nlock": "Recupero fondi"
    },
    "recovery": {
      "title": "Recupero fondi",
      "caption": "Nel caso il server divenisse irraggiungibile, queste informazioni saranno utili per recuperare i fondi."
    },
    "nlock": {
      "title": "Recupero fondi",
      "caption": "Questo è un conto con <b>firma del server</b>. Questo strumento è utile per recuperare i fondi nel caso il server si renda indisponibile.",
      "reminder": {
        "title": "Alcuni unspent sono scaduti o stanno per scadere",
        "caption": "Gli unspent scaduti non possono essere protetti dal server. Verrebbero rinnovati facendo una transazione, oppure, puoi rinnovarli esplicitamente qui."
      },
      "recovery": {
        "title": "File di recovery",
        "caption": "Un file di recovery può essere usato con il <b>Melis Recovery Tool</b> nel caso il server non funzionasse o non fosse disponibile, per recuperare i fondi",
        "retr": "C'è un file di recovery pronto",
        "time": "La durata delle informazioni di recovery è <b>{{days}} giorni</b>.",
        "disabled": "Le informazioni di recovery sono disattivate. <b>E' possibile che la cosa abbia conseguenze sulla capacità di recuperare i fondi nel caso il server diventasse irraggiungibile.</b>",
        "nofile": "Non c'è un file di recovery pronto, fai refresh per scaricarne uno",
        "info": "Queste sono le informazioni per recuperare il tuo account.",
        "nomail": "Su questa piattaforma i file di recovery sono inviati tramite mail. E' necessario configurare una applicazione email."
      },
      "unspents": {
        "title": "Transazioni non spese in scadenza",
        "caption": "Le transazioni vanno rinnovate prima della scadenza, in maniera da mantenere la sicurezza garantitta dalla firma del server",
        "block": "conferme",
        "expires": "scadenza",
        "amount": "saldo",
        "none": "Non ci sono unspent in scadenza."
      },
      "transaction": {
        "title": "Conferma della transazione",
        "caption": "La rotazione delle transazioni non spese è soggetta ad un costo da parte della rete della coin, in quanto è una normale transazione:",
        "fees": "Commissioni:",
        "error": "Si è verificato un errore durante la transazione."
      },
      "tx": {
        "multi": "Questo è un conto multifirma, sarà necessaria l'autorizzazione dei cofirmatari per completare il rinnovo degli unspents",
        "success": "Gli unspent sono stati rinnovati correttamente."
      },
      "rotate": {
        "all": "Rinnova tutti",
        "some": {
          "one": "Rinnova selezionato",
          "other": "Rinnova {{count}} unspents"
        }
      },
      "time": {
        "ph": "modifica il tempo",
        "current": "valore corrente",
        "1mo": "1 mese",
        "3mo": "3 mesi",
        "6mo": "6 mesi",
        "disabled": "disattivato"
      },
      "url": {
        "title": "Applicazione di recovery",
        "caption": "Nel caso questa applicazione diventasse indisponibile, è possibile recuperare i fondi con l'applicazione (statica) raggiungibile a questi indirizzi"
      }
    },
    "prefs": {
      "title": "Prefenze conto",
      "type": "tipo",
      "account": {
        "num": "Numero del conto:",
        "name": "Nome:",
        "created": "Creato:",
        "color": "Color:",
        "identifier": "Identificatore:"
      },
      "profile": {
        "title": "Profilo pubblico",
        "caption": "Queste informazioni sono pubbliche. Sono visibili nella pagina del tuo profilo e vengono mostrate agli utenti Melis quando effettuano una ricerca."
      },
      "alias": {
        "title": "Alias",
        "caption": "Un alias è un nome univoco utilizzato per identificare te stesso all'interno di Melis"
      },
      "ident": {
        "title": "Identità Pubblica",
        "caption": "Usa questa identità per abilitare terze persone ad inviarti pagamenti e messaggi"
      }
    }
  },
  "wallet": {
    "title": "Settaggi del Wallet",
    "no-creds": {
      "title": "Non è più possibile accedere al wallet da questo dispositivo",
      "caption": "Le credenziali di questo dispositivo sono state rimosse per ragioni di sicurezza. E' ora necessario associarlo di nuovo, oppure recuperare un backup."
    },
    "options": {
      "enroll": "Sottoscrivi un nuovo wallet",
      "pair": "Associa questo dispositivo",
      "recover": "Importa da una scheda backup",
      "import": "Apri un wallet dai mnemonics"
    },
    "prefs": {
      "title": "Preferenze",
      "caption": "Mostra preferenze",
      "notif": {
        "title": "Notifiche",
        "caption": "Le notifiche comunicano gli eventi importanti in tempo reale",
        "native": {
          "t": "Notifiche Desktop",
          "c": "Le notifiche desktop compaiono quando l'applicazione non è in primo piano"
        },
        "inapp": {
          "t": "Notifiche in-app",
          "c": "Le notifiche in-app compaiono all'interno dell'applicazione mentre viene usata"
        },
        "push": {
          "t": "Notifiche Push",
          "c": "Le notifiche push sono mostrate anche quando l'applicazione è chiusa"
        }
      },
      "app": {
        "title": "Questa applicazione",
        "caption": "Informazioni sull'applicazione Melis Wallet.",
        "version": "Versione",
        "network": "Rete",
        "license": "Licenza",
        "review": "Rivedi la licenza"
      },
      "coinunit": {
        "title": "Unità Coin",
        "caption": "Scegli l'unità coin preferita"
      },
      "currency": {
        "title": "Valuta",
        "caption": "Scegli la tua valuta preferita",
        "pholder": "Valuta globale"
      },
      "exchange": {
        "title": "Exchange di riferimento",
        "caption": "L'exchange da cui prendere il valore della coin"
      },
      "locale": {
        "title": "Lingua",
        "caption": "Seleziona la lingua preferita"
      },
      "explorer": {
        "title": "Transaction explorer",
        "caption": "Seleziona il servizio esterno usato per mostrare lo stato delle trasazioni"
      },
      "fp-avail": {
        "title": "Autenticazione con l'impronta digitale",
        "caption": "Questo dispositivo supporta l'autenticazione con impronta digitale, ma nessuna impronta è configurata. E' necessario acquisire le impronte digitali nelle preferenze del sistema"
      },
      "fingerprint": {
        "title": "Autenticazione con l'impronta digitale",
        "caption": "Attivando l'autenticazione con imponta digitale, potrai usarla in luogo del PIN (anche per effettuare il log in)",
        "label": "attiva impronta digitale"
      },
      "telemetry": {
        "title": "Informazioni di debug",
        "caption": "Melis raccoglie informazioni sull'applicazione in casi di eventi eccezionali"
      },
      "t-error": {
        "t": "Invia le informazioni di errore",
        "c": "Invia a Melis informazioni riguardo agli errori ed eccezioni al solo scopo di risolvere i problemi e migliorare il servizio."
      }
    },
    "devices": {
      "title": "Lista dei dispositivi che hanno accesso al tuo wallet",
      "caption": "In questa sezione puoi gestire i dispositivi utilizzati per accedere al tuo wallet e puoi associare altri dispositivi",
      "prchange": {
        "title": "Ritardo cambio primario",
        "caption": "Per ragioni di sicurezza il cambio del primario è soggetto ad un ritardo",
        "days": {
          "one": "<b>Un giorno</b>",
          "other": "<b>{{count}} giorni</b>."
        }
      },
      "non-prim": {
        "title": "Questo dispositivo non è primario",
        "caption": ""
      },
      "name": {
        "title": "Il nome di questo dispositivo",
        "caption": ""
      },
      "primary": {
        "title": "Questo è il dispositivo primario",
        "caption": "Il dispositivo primario ha il controllo degli altri dispositivi e può vedere i conti sicuri",
        "scheduled": "Un altro dispositivo è in programma per diventare primario <b>{{relative}}</b> il {{when}}",
        "willchange": "Questo dispositivio diventerà primario <b>{{relative}}</b> il {{when}}",
        "make": "Rendi primario",
        "cancel": "No, mantieni questo primario"
      },
      "list": {
        "name": "Nome del dispositivo",
        "last": "Ultimo accesso",
        "new-prim": "Nuovo primario",
        "this": "questo",
        "promote": "Rendi primario",
        "delete": "Cancella il device",
        "deleteall": "Cancella <b>tutti</b> gli altri dispositivi",
        "wpromote": {
          "title": "Promuovi primario, attenzione",
          "caption": "Promuovendo un device a primario, questo device perderà accesso ad alcune features: in particolare non potrà piu accedere ai conti marcati come <b>sicuri</b>. <i>La promozione a primario è immediata</i>"
        },
        "wdelete": {
          "title": "Disassocia un dispositivo attenzione",
          "caption": "Se didassoci un dispositivo non sarai più in grado di utilizzarlo per accedere al tuo wallet. Dovrai ripristinare un backup oppure associarlo di nuovo."
        }
      },
      "delete": {
        "title": "Scollega dispositivi",
        "caption": "Puoi scollegare tutti gli altri dispositivi dall'account Melis. Saranno recessarie le parole mnemoniche, oppure un backup per ricollegarli."
      },
      "pair": {
        "title": "Collega un nuovo dispositivo",
        "caption": "Puoi permettere a diversi dispositivi di accedere al tuo wallet. Collegare un dispositivo è semplice come fare una fotografia.",
        "warn": "Fai attenzione. Collegare un dispositivo può consentire a chi ha accesso a quel dispositivo di accedere ai tuoi fondi oppure ad informazioni sensibili conoscendo o indovinando il tuo PIN."
      }
    },
    "maint": {
      "title": "Manutenzione",
      "caption": "In questa pagina puoi accedere a varie utilità. Questa pagina sarà riorganizzata nelle versioni future.",
      "backup": {
        "title": "Backup delle credenziali",
        "caption": "Utilizza questa procedura guidata per fare il backup delle tue credenziali così potrai accedere al tuo wallet ovunque oltre a recuperare l'accesso al tuo wallet se questo dispositivo smetterà di funzionare.",
        "btn": "Fai il backup ora"
      },
      "backupck": {
        "title": "Verifica backup",
        "caption": "Verifica se un backup cartaceo o una lista di mnemonic sono funzionanti.",
        "btn": "Verifica"
      },
      "new": {
        "title": "Nuovo conto",
        "caption": "Crea un nuovo conto. Puoi scegliere diversi tipi di conto singolo utente o multiutente con o senza la firma del server.",
        "btn": "Crea un nuovo conto"
      },
      "join": {
        "title": "Aderisci ad un conto multifirma",
        "caption": "Se hai un codice d'adesione puoi usarlo qui per aderire ad un conto come cofirmatario",
        "btn": "Aderisci al conto"
      },
      "pin": {
        "title": "Modifica Pin",
        "caption": "Utilizza questa procedura guidata per modificare il PIN utilizzato"
      },
      "danger": {
        "title": "Zona pericolosa",
        "caption": "Questa operazione abiliterà operazioni pericolose"
      },
      "delete": {
        "title": "Cancella le credenziali",
        "caption": "Cancella le credenziali conservate su questo dispositivo. Dovrai utilizzare i tuoi mnemonics per accedere di nuovo al wallet.",
        "btn": "CANCELLA"
      },
      "wdelete": {
        "title": "CANCELLA LE CREDENZIALI",
        "caption": "L'operazione cancellerà tutte le credenziali dal dispositivo. Sarà necessario utilizzare un altro dispositivo, oppure un backup per accedere ai fondi. <b>Sei davvero sicuro?</b>"
      }
    },
    "signed": {
      "noacct": {
        "title": "Non hai ancora conti",
        "caption": "Devi creare il tuo primo conto per iniziare a ricevere fondi"
      },
      "create": "Crea il tuo primo conto",
      "success": {
        "title": "Attenzione versione preliminare",
        "caption": "Questa è una versione preliminare: usala di conseguenza e non tenere importi elevati di denaro o dati",
        "link": "Vai al Menù"
      }
    },
    "signin": {
      "error": {
        "short": "Errore di accesso",
        "invalid": "Dispositivo non valido",
        "generic": "Si è verificato un errore nel server durante l'accesso. Puoi riprovare tra qualche minuto.",
        "wrong": "PIN errato. {{attempts}} tentativi rimasti."
      },
      "prompt": "Inserisci il PIN",
      "pin": "PIN",
      "barred": {
        "title": "Questa versione del client Melis non è piu supportata",
        "caption": "Questa versione del client è vecchia e non è più compatibile con il servizio. Aggiorna il client in modo da poter accedere nuovamente."
      },
      "locked": {
        "title": "PIN login disabled",
        "caption": "Le credenziali sono state cancellate da questo dispositivo. Devi accedere utilizzando i tuoi mnemonics."
      },
      "last": {
        "title": "Ultimo tentativo disponibile",
        "caption": "Hai solo un ultimo tentativo per accedere con il tuo PIN. Se inserisci di nuovo un PIN errato avrai bisogno del tuo backup per accedere di nuovo."
      },
      "new": "Crea un nuovo wallet"
    },
    "sidebar": {
      "about": {
        "title": "About",
        "caption": "Preferenze ed impostazioni per l'applicazione Melis"
      },
      "backup": {
        "title": "Backup delle credenziali",
        "never": "mai",
        "confirmed": "Eseguito:",
        "checked": "Verificato:"
      }
    },
    "passphrase": {
      "pass": {
        "label": "Inserisci una passphrase",
        "ph": "passphrase..."
      },
      "check": {
        "label": "Ripeti la passphrase",
        "ph": "passphrase..."
      }
    },
    "pin": {
      "set": {
        "label": "Nuovo PIN",
        "ph": "Inserisci un nuovo pin..."
      },
      "check": {
        "label": "Ripeti il PIN",
        "ph": "Ripeti il nuovo PIN..."
      },
      "label": "PIN",
      "ph": "Inserisci il tuo PIN...",
      "left": "{{count}} ulteriori tentativi",
      "nocreds": {
        "title": "Credenziali non valide",
        "caption": "Questo client non ha nessuna credenziale valida per il wallet."
      }
    },
    "mnemo": {
      "input": {
        "label": "Credenziali portafoglio",
        "ph": "Inserisci i mnemonics criptati o in chiaro..."
      },
      "pass": {
        "label": "Passphrase",
        "ph": "Inserisci la passphrase per decriptare le credenziali...",
        "clip": "Incolla dagli appunti"
      }
    },
    "import": {
      "w": {
        "t-check": {
          "caption": "Sei sicuro?",
          "desc": "Fai attenzione"
        },
        "t-mnemonics": {
          "caption": "Mnemonics",
          "desc": "Scrivi i tuoi Mnemonics"
        },
        "t-pin": {
          "caption": "PIN",
          "desc": "Imposta il tuo PIN"
        },
        "t-open": {
          "caption": "Apri",
          "desc": "Accesso al tuo wallet"
        },
        "warn": {
          "title": "Presta attenzione. Associare o importare un nuovo wallet distrugge le credenziali correnti.",
          "caption": "Questo dispositivo ha già memorizzato le credenziali per un wallet. Se procedi ora verranno distrutte perderai l'accesso al wallet a meno che non disponi del backup."
        },
        "input": {
          "title": "Mnemonics backup",
          "caption": "Inserisci la lista di parole associata al backup del tuo wallet. Se hai una scheda di backup le parole sono scritte in fondo al foglio."
        },
        "pin": {
          "title": "PIN",
          "caption": "Imposta un PIN per proteggere il dispositivo"
        },
        "importing": {
          "title": "Importazione delle informazioni",
          "caption": "Le tue mnemonics vengono decodificate e il server importa le informazioni"
        },
        "done": {
          "title": "Fatto",
          "caption": "Hai aperto correttamente il tuo wallet."
        },
        "wrong": {
          "title": "Credenziali errate",
          "caption": "La passphrase o gli mnemonics sono errati e Melis non può aprire il tuo wallet",
          "warn": "Il backup era criptato e quindi la cosa più  probabile è che tu abbia scritto la passphrase in modo errato. Verifica è prova di nuovo."
        },
        "failed": {
          "title": "Si è verificato un errore importando il wallet",
          "caption": ""
        },
        "noacc": {
          "title": "Questo wallet non ha accounts",
          "caption": "Il wallet che hai appena aperto non ha account visibili. E' possibile crearne uno ora"
        },
        "createacct": "Crea un nuovo account",
        "summary": "Il tuo wallet"
      }
    },
    "backup": {
      "ok": "Il backup dei mnemonics è stato completato",
      "missing": "Il backup dei mnemonics non è stato completato!",
      "w": {
        "t-pin": {
          "caption": "PIN",
          "desc": "Inserisci il tuo PIN"
        },
        "t-export": {
          "caption": "Esporta",
          "desc": "Una passphrase per proteggere i tuoi mnemonics"
        },
        "t-backup": {
          "caption": "Backup",
          "desc": "Scrivi i tuoi mnemonics"
        },
        "t-confirm": {
          "caption": "Conferma",
          "desc": "Conferma il tuo backup"
        },
        "complete": {
          "title": "Lo sapevi?",
          "caption": "Questo backup è l'unica cosa di cui hai bisogno indipendentemente dal numero di conti e transazioni che farai sul tuo wallet. Conservalo in un luogo molto sicuro.",
          "summary": "Accedi al tuo wallet"
        },
        "pin": {
          "title": "Accesso alle tue credenziali",
          "caption": "L'operazione di backup ha bisogno che inserisci il tuo PIN per accedere alle credenziali memorizzate sul dispositivo."
        },
        "pass": {
          "title": "Proteggi il tuo backup",
          "caption": "E' possibile proteggere il tuo backup con una passphrase. Proteggere il backup lo rende sicuro anche nel caso in cui qualcuno ha accesso alla backup card o ai mnemonics perchè per utilizzarli viene richiesta la passphrase.",
          "warn": "Se proteggi il tuo backup assicurati di non dimenticare la passphrase. Se lo fai non c'è modo di recuperarla e il backup sarà inutile e potrai perdere l'accesso al wallet ed ai tuoi fondi.",
          "unencrypted": "Esporta senza passphrase.",
          "encrypted": "Proteggi il mio backup"
        },
        "mnemonic": {
          "title": "I tuoi Wallet Mnemonics",
          "caption": "Scrivi queste parole e conservale in un luogo molto sicuro",
          "clip": "Copia i mnemonics negli appunti"
        },
        "store": {
          "title": "Conserva i tuoi mnemonics in un luogo molto sicuro",
          "caption": "Devi fare il backup una sola volta indipendemente dal numero di conti o transazioni effettuate."
        }
      }
    }
  },
  "welcome": {
    "enroll": {
      "title": "Benvenuto al Wallet Melis",
      "caption": "",
      "new": {
        "title": "Non ho un wallet Melis",
        "caption": "Non ho un wallet e voglio sottoscriverne uno. La sottoscrizione è un processo semplice che richiede pochi secondi."
      },
      "import": {
        "title": "Ho un wallet Melis",
        "caption": "Ho già un wallet Melis e voglio associare ed importare le credenziali su questo dispositivo oppure ripristinare un backup."
      }
    },
    "has-credentials": "Sembra che ci siano già delle credenziali memorizzate su qeusto dispositivo. Se procedi verranno cancellate.",
    "pair": {
      "title": "Ho il wallet su un altro dispositivo",
      "caption": ""
    },
    "recover": {
      "title": "Ho un backup cartaceo",
      "caption": ""
    },
    "import": {
      "title": "Ho una lista di mnemonics",
      "caption": ""
    }
  },
  "pair": {
    "tabs": {
      "pin": {
        "caption": "Inserisci il PIN",
        "descr": "Inserisci il tuo PIN"
      },
      "name": {
        "caption": "Nome del dispositivo",
        "descr": "Un nome che identifica il dispositivo"
      },
      "gen": {
        "caption": "Associa",
        "descr": "Acquisisci il codice QR dal dispostivo di destinazione"
      }
    },
    "source": {
      "title": "Inizia la procedura di associazione sul dispositivo di origine",
      "caption": "Apri Melis sul dispositivo di origine vai alle impostazioni del wallet e inizia la procedura di associazione. Una volta ottenuta l'immagine del codice di associazione procedi al prossimo passo."
    },
    "w": {
      "pin": {
        "title": "Sblocca le tue credenziali",
        "caption": "Melis necessita di accedere alle tue credenziali per poterle trasferire al nuovo dispositivo e quindi ti è richiesto di immettere il PIN. Al termine della procedura di associazione il nuovo dispositivo avrà lo stesso PIN."
      },
      "name": {
        "title": "Nome del tuo dispositivo",
        "caption": "Dare un nome al tuo dispositivo permette di identificarli e di gestire i privilegi per ciascuno"
      },
      "code": {
        "title": "Acquisisci questo codice dall'applicazione Melis del tuo nuovo dispositivo",
        "caption": "Sul nuovo dispositivo seleziona l'opzione per associarlo ad un wallet esistente e apri la fotocamera su questa immagine:"
      }
    },
    "import": {
      "tabs": {
        "qrcode": {
          "caption": "Scansione del codice QR",
          "descr": "Usa la tua telecamera"
        },
        "source": {
          "caption": "Dispositivo sorgente",
          "descr": "Prepare for pairing"
        },
        "pin": {
          "caption": "PIN",
          "descr": "Il tuo PIN"
        }
      },
      "title": "Clicca sull'icona per aprire la telecamera",
      "caption": "Se hai un codice QR visualizzato sul device di origine apri la fotocamera su questo dispositivo e inquadra l'immagine del codice",
      "error": "<b>Si è verificato un errore mentre associavi il dispositivo</b>: Riprova la procedura.",
      "scan-error": "<b>Impossibile leggere un QR code valido per il pairing</b>. Verificate di utilizzare un QR code per il pairing e non quello di una scheda di backup.",
      "pin": {
        "title": "Abbiamo bisogno del tuo PIN",
        "caption": "Inserisci il PIN del tuo wallet questo diventerà anche il PIN di questo dispositivo. Potrai cambiarlo nelle prefenze.",
        "wrong": "PIN non valido",
        "ph": "PIN..."
      },
      "success": {
        "title": "Associazione completata",
        "caption": "Ora puoi accedere al tuo wallet da questo dispositivo"
      },
      "device": {
        "invalid": "Dispositivo non valido"
      },
      "data": {
        "ph": "Paste raw data here..."
      }
    }
  },
  "info": {
    "backup": {
      "title": "Scheda Backup",
      "caption": "Questa scheda backup viene utilizzata per ripristinare l'accesso al tuo wallet in caso il tuo dispositivo venga perso o nel caso le credenziali dentro al dispositivo siano cancellate. Questo foglio contiene tutte le informazioni necessarie ad accedere al tuo wallet ed ai tuoi fondi. <b>Se hai scelto di criptare il backup sarà necessaria anche la passphrase per sbloccare le informazioni contenute nel backup.</b> Se smarrisci il backup o dimentichi la passphrase perderai l'accesso ai fondi contenuti nel wallet. Non c'è alcun altro modo di recuperarli.",
      "warn": "mantieni questo foglio segreto",
      "instructions": "Chiunque abbia accesso a questa scheda puo accedere al tuo wallet trasferire i tuoi fondi e impersonarti nei conti a firma multipla.",
      "additional": "Puoi recuperare questo backup mediante la procedura con la fotocamera scandendo il QR code o digitando le parole mnemoniche nel box in fondo",
      "mnemo": {
        "title": "Parole Mnemoniche",
        "caption": "Le parole mnemoniche sono utilizzate per recuperare un backup nel caso il tuo dispositivo non abbia una fotocamera per acquisire il codice QR. Le parole contengono la medesima informazione del QR code e sebbene possano essere scritte e copiate altrove devono essere considerate altrettanto importanti e riservate del codice ."
      }
    }
  },
  "noserver": {
    "title": "Files di ripristino",
    "caption": "I file di ripristino possono essere usati nel<b>Melis Recovery Tool</b> per recuperare i fondi nel caso in cui il server Melis non sia disponibile.",
    "updated": "Aggiornato {{when}}."
  },
  "cnfail": {
    "title": "Impossibile connettersi alla rete Melis",
    "caption": "Non è stato possibile connettersi alla rete melis. potrebbe essere down oppure irraggiungibile.",
    "button": "Recovery mode"
  },
  "sign": {
    "message": {
      "title": "Firma con indirizzo",
      "noaddr": "Nessun indirizzo disponibile",
      "text": "Testo da firmare:",
      "with": "Con l'indirizzo:",
      "sign": "Firma",
      "dismiss": "Chiudi",
      "findaddr": {
        "title": "Indirizzo per firma",
        "caption": "Puoi usare uno dei tuoi indirizzi per firmare un messaggio."
      }
    },
    "check": {
      "title": "Controllo Firma",
      "dismiss": "Chiudi",
      "valid": "La firma è valida.",
      "invalid": "La firma<b>non</b> è valida.",
      "text": "Testo firmato:",
      "address": "Indirizzo",
      "signature": "Firma",
      "check": "Verifica firma",
      "button": "Verifica firma"
    }
  },
  "cm": {
    "ex": {
      "spendableLimitReached": "Il limite {{type}} per {{hours}} ore verrebbe superato: {{alreadySpent}} già spesi, {{amountToSpend}} richiesti. Il limite è: {{limit}} (satoshis)"
    }
  }
};
