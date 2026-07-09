(function () {
  const STORAGE_KEY = 'btf-lang';

  const translations = {
    en: {
      metaTitle: 'BetaTest Flow | Flutter Beta Testing SDK',
      metaDescription:
        'BetaTest Flow: Flutter Beta Testing SDK to capture real feedback and ship with confidence.',
      hero: {
        subtitle: 'Flutter Beta Testing SDK',
        flow: 'Collect feedback.<br>Analyze results.<br><span>Ship with confidence.</span>',
        lead:
          'Capture structured beta feedback, export executive reports, and turn QA noise into clear release actions.',
        ctaStart: 'Get Started',
        ctaDemo: 'View Demo Report',
      },
      problem: {
        title: 'Problem',
        body:
          'In real betas, feedback gets scattered across chats, screenshots, and notes. That slows critical fixes and makes release decisions subjective.',
      },
      solution: {
        title: 'Solution',
        body:
          'BetaTest Flow standardizes Flutter report capture and produces actionable outputs: Executive Report, Release Decision, Beta Confidence Score, 48h Action Plan, and AI Correction Prompt.',
      },
      cas: {
        title: 'Collect. Analyze. Ship.',
        collect: {
          title: 'Collect',
          li1: 'Embed a reusable feedback widget.',
          li2: 'Capture structured beta reports.',
          li3: 'Avoid spreadsheets and scattered feedback.',
        },
        analyze: {
          title: 'Analyze',
          li1: 'Generate Executive Reports.',
          li2: 'Get Release Decisions.',
          li3: 'Track Beta Confidence Score.',
        },
        ship: {
          title: 'Ship',
          li1: 'Use the 48h Action Plan.',
          li2: 'Copy the AI Correction Prompt.',
          li3: 'Fix with Copilot, Cursor, ChatGPT or Gemini.',
        },
      },
      how: {
        title: 'How it works',
        li1: 'Integrate the SDK in your Flutter app and enable the feedback widget.',
        li2: 'Collect structured campaign reports in Firestore or offline JSON.',
        li3: 'Run export and get an executive summary with decision and action plan.',
      },
      report: {
        title: 'Executive report preview',
        exec: 'Operational summary of severity, outcomes, screens, and UX observations.',
        decision:
          'GO / GO WITH CONDITIONS / NO-GO state with rationale and release conditions.',
        score:
          'Overall score plus subscores for stability, usability, and release readiness.',
        planTitle: '48h Action Plan',
        planBody:
          'P1-P5 prioritization with suggested action and validation criteria per item.',
        prompt: 'Prompt ready to execute corrections guided by real beta evidence.',
      },
      install: {
        title: 'Quick install',
        body: 'Add the SDK dependency in the host app and sync packages.',
      },
      offline: {
        title: 'Offline demo',
        body: "Generate reports without Firestore by using the project's official fixture.",
      },
      status: {
        title: 'SDK Status',
        sdkVersion: 'SDK Version',
        analysisEngine: 'Analysis Engine',
        executiveReport: 'Executive Report',
        offlineMode: 'Offline Mode',
        tests: 'Tests',
        backwardCompatibility: 'Backwards Compatibility',
        ready: 'Ready',
        available: 'Available',
        testsValue: '19 passing',
        preserved: 'Preserved',
      },
      roadmap: {
        title: 'Roadmap',
        v001: 'Reusable SDK validated.',
        v002: 'BUSKIA functional parity.',
        v003:
          'Analysis Engine + Executive Report + Decision + Score + 48h Plan + AI Prompt.',
        v010: 'Professional developer experience and multi-team adoption.',
        v100: 'Mature beta testing platform.',
      },
      cta: {
        title: 'Ready to professionalize your beta workflow',
        body: 'Start with minimal setup and evolve into evidence-based release decisions.',
        button: 'View on GitHub',
      },
      footer: {
        legal: 'BetaTest Flow SDK v0.1.0 | Legal: Privacy | Terms | License',
      },
    },
    es: {
      metaTitle: 'BetaTest Flow | SDK de Beta Testing para Flutter',
      metaDescription:
        'BetaTest Flow: SDK de beta testing para Flutter para capturar feedback real y publicar con confianza.',
      hero: {
        subtitle: 'SDK de Beta Testing para Flutter',
        flow: 'Recolecta feedback.<br>Analiza resultados.<br><span>Publica con confianza.</span>',
        lead:
          'Captura feedback beta estructurado, exporta reportes ejecutivos y convierte el ruido de QA en acciones claras de release.',
        ctaStart: 'Comenzar',
        ctaDemo: 'Ver Reporte Demo',
      },
      problem: {
        title: 'Problema',
        body:
          'En betas reales, el feedback queda disperso entre chats, capturas y notas. Eso retrasa fixes criticos y vuelve subjetiva la decision de publicar.',
      },
      solution: {
        title: 'Solucion',
        body:
          'BetaTest Flow estandariza la captura de reportes en Flutter y genera salidas accionables: Executive Report, Release Decision, Beta Confidence Score, Plan de accion 48h y AI Correction Prompt.',
      },
      cas: {
        title: 'Recolecta. Analiza. Publica.',
        collect: {
          title: 'Recolecta',
          li1: 'Integra un widget de feedback reutilizable.',
          li2: 'Captura reportes beta estructurados.',
          li3: 'Evita planillas y feedback disperso.',
        },
        analyze: {
          title: 'Analiza',
          li1: 'Genera Executive Reports.',
          li2: 'Obtiene Release Decisions.',
          li3: 'Sigue el Beta Confidence Score.',
        },
        ship: {
          title: 'Publica',
          li1: 'Usa el Plan de accion 48h.',
          li2: 'Copia el AI Correction Prompt.',
          li3: 'Corrige con Copilot, Cursor, ChatGPT o Gemini.',
        },
      },
      how: {
        title: 'Como funciona',
        li1: 'Integra el SDK en tu app Flutter y habilita el widget de feedback.',
        li2: 'Recolecta reportes estructurados por campana en Firestore o JSON offline.',
        li3: 'Ejecuta export y obten un resumen ejecutivo con decision y plan de accion.',
      },
      report: {
        title: 'Vista del informe ejecutivo',
        exec: 'Resumen operativo de severidad, resultados, pantallas y observaciones UX.',
        decision:
          'Estado GO / GO CON CONDICIONES / NO-GO con razon y condiciones de salida.',
        score:
          'Score global y subscores para estabilidad, usabilidad y release readiness.',
        planTitle: 'Plan de accion 48h',
        planBody:
          'Priorizacion P1-P5 con accion sugerida y criterio de validacion por item.',
        prompt: 'Prompt listo para ejecutar correcciones guiadas por evidencia real de beta.',
      },
      install: {
        title: 'Instalacion rapida',
        body: 'Agrega la dependencia del SDK en la app host y sincroniza paquetes.',
      },
      offline: {
        title: 'Demo offline',
        body: 'Genera reportes sin depender de Firestore usando el fixture oficial del proyecto.',
      },
      status: {
        title: 'Estado del SDK',
        sdkVersion: 'Version del SDK',
        analysisEngine: 'Analysis Engine',
        executiveReport: 'Executive Report',
        offlineMode: 'Modo Offline',
        tests: 'Tests',
        backwardCompatibility: 'Compatibilidad hacia atras',
        ready: 'Listo',
        available: 'Disponible',
        testsValue: '19 en verde',
        preserved: 'Preservada',
      },
      roadmap: {
        title: 'Roadmap',
        v001: 'SDK reutilizable validado.',
        v002: 'Paridad funcional BUSKIA.',
        v003:
          'Analysis Engine + Executive Report + Decision + Score + Plan 48h + AI Prompt.',
        v010: 'Experiencia profesional para developers y adopcion multi-equipo.',
        v100: 'Plataforma madura de beta testing.',
      },
      cta: {
        title: 'Listo para profesionalizar tu flujo beta',
        body: 'Empieza con instalacion minima y evoluciona hacia decisiones de release basadas en evidencia.',
        button: 'Ver en GitHub',
      },
      footer: {
        legal: 'BetaTest Flow SDK v0.1.0 | Legal: Privacidad | Terminos | Licencia',
      },
    },
  };

  function getValue(obj, key) {
    return key.split('.').reduce((acc, part) => (acc && acc[part] !== undefined ? acc[part] : null), obj);
  }

  function applyLanguage(lang) {
    const dictionary = translations[lang] || translations.en;

    document.documentElement.lang = lang;
    document.title = dictionary.metaTitle;

    const metaDescription = document.getElementById('meta-description');
    if (metaDescription) {
      metaDescription.setAttribute('content', dictionary.metaDescription);
    }

    document.querySelectorAll('[data-i18n]').forEach((el) => {
      const key = el.getAttribute('data-i18n');
      const value = getValue(dictionary, key);
      if (typeof value === 'string') {
        el.textContent = value;
      }
    });

    document.querySelectorAll('[data-i18n-html]').forEach((el) => {
      const key = el.getAttribute('data-i18n-html');
      const value = getValue(dictionary, key);
      if (typeof value === 'string') {
        el.innerHTML = value;
      }
    });

    document.querySelectorAll('[data-lang]').forEach((button) => {
      const isActive = button.getAttribute('data-lang') === lang;
      button.classList.toggle('is-active', isActive);
      button.setAttribute('aria-pressed', isActive ? 'true' : 'false');
    });

    localStorage.setItem(STORAGE_KEY, lang);
  }

  const stored = localStorage.getItem(STORAGE_KEY);
  const initialLang = stored === 'es' ? 'es' : 'en';
  applyLanguage(initialLang);

  document.querySelectorAll('[data-lang]').forEach((button) => {
    button.addEventListener('click', () => {
      const lang = button.getAttribute('data-lang');
      if (lang === 'en' || lang === 'es') {
        applyLanguage(lang);
      }
    });
  });
})();
