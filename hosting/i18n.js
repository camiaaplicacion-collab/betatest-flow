(function () {
  const STORAGE_KEY = 'btf-lang';
  let currentLang = 'en';

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
        ctaTryDemo: 'Try the Demo',
        ctaDemo: 'View Demo Report',
      },
      nav: {
        documentation: 'Documentation',
      },
      shared: {
        getAiPromptCta: 'Get AI Fix Prompt',
      },
      share: {
        hero: 'Share',
        cta: 'Share BetaTest Flow',
        copied: 'Link copied',
        title: 'BetaTest Flow',
        text:
          'Flutter Beta Testing SDK: collect feedback, analyze results and ship with confidence.',
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
      documentation: {
        title: 'Documentation',
        intro:
          'Build your integration path step by step. Start fast, then go deeper into export and analysis workflows.',
        estimatedTime: 'Estimated time',
        level: 'Level',
        comingNext: 'Coming next',
        readGuide: 'Read guide',
        gettingStarted: {
          title: 'Getting Started',
          description:
            'Understand the core flow and minimum setup to start collecting beta feedback.',
          time: '5 min',
          level: 'Beginner',
        },
        installation: {
          title: 'Installation',
          description:
            'Set dependency, run package sync, and prepare your host app environment.',
          time: '8 min',
          level: 'Beginner',
        },
        firstReport: {
          title: 'First Beta Report',
          description:
            'Create your first complete report and validate the end-to-end capture flow.',
          time: '10 min',
          level: 'Beginner',
        },
        exportReports: {
          title: 'Export Reports',
          description:
            'Generate JSON, CSV and markdown outputs from Firestore or offline fixtures.',
          time: '5 min',
          level: 'Intermediate',
        },
        analysisEngine: {
          title: 'Analysis Engine',
          description:
            'Interpret release decision, confidence score, and 48h action priorities.',
          time: '5 min',
          level: 'Intermediate',
        },
        faq: {
          title: 'FAQ',
          description:
            'Resolve common integration and troubleshooting questions quickly.',
          time: '7 min',
          level: 'Advanced',
        },
      },
      gettingStarted: {
        title: 'Getting Started',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '5 minutes',
        levelLabel: 'Level',
        levelValue: 'Beginner',
        learnTitle: 'What you will learn',
        learnBody:
          'You will understand the minimum integration path, when to run exports, and how to use analysis outputs to ship with confidence.',
        whatIsTitle: 'What is BetaTest Flow',
        whatIsBody:
          'BetaTest Flow is a reusable Flutter SDK to capture structured beta feedback and convert it into actionable release guidance.',
        whenToUseTitle: 'When to use it',
        whenToUseBody:
          'Use it when your team needs a repeatable beta process, clear release criteria, and faster feedback-to-fix cycles.',
        flowTitle: 'Complete flow',
        flowLine:
          'Flutter App -> SDK Widget -> Firestore/JSON -> Analysis Engine -> Executive Report -> AI Correction Prompt',
        expectedTitle: 'Expected outcome',
        expectedBody:
          'At the end, you have one structured report pipeline and a clear action path for release decisions and corrections.',
      },
      installationGuide: {
        title: 'Installation',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '5 minutes',
        levelLabel: 'Level',
        levelValue: 'Beginner',
        requirementsTitle: 'Requirements',
        req1: 'Flutter >= 3.35.0',
        req2: 'Firebase project if using Firestore mode',
        req3: 'Offline JSON mode available without Firebase',
        dependencyTitle: 'Install dependency',
        importTitle: 'Import SDK',
        firstButtonTitle: 'Add your first button',
        expectedTitle: 'Expected outcome',
        expectedBody:
          'A feedback button is visible in your app and ready to capture beta reports.',
      },
      firstReportGuide: {
        title: 'First Beta Report',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '10 minutes',
        levelLabel: 'Level',
        levelValue: 'Beginner',
        flowTitle: 'Flow',
        step1: 'Add BetaFeedbackButton',
        step2: 'Tester sends feedback',
        step3: 'Report is saved',
        step4: 'Export reports',
        step5: 'Generate Executive Report',
        expectedTitle: 'Expected outcome',
        expectedBody: 'First structured beta report ready for analysis.',
      },
      exportReportsGuide: {
        title: 'Export Reports',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '5 minutes',
        levelLabel: 'Level',
        levelValue: 'Intermediate',
        modesTitle: 'Export modes',
        modeA: 'A) Firestore mode',
        modeB: 'B) Offline JSON mode',
        offlineCommandTitle: 'Offline command',
        outputsTitle: 'Generated outputs',
        expectedTitle: 'Expected outcome',
        expectedBody: 'Executive Report generated locally without Firebase.',
      },
      analysisEngineGuide: {
        title: 'Analysis Engine',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '5 minutes',
        levelLabel: 'Level',
        levelValue: 'Intermediate',
        intro:
          'The engine automatically analyzes every beta report and generates actionable guidance for the development team.',
        decisionTitle: 'Release Decision',
        decisionBody: 'Automatically classifies release state as:',
        scoreTitle: 'Beta Confidence Score',
        scoreBody: 'Generates the following score dimensions:',
        planTitle: 'Action Plan 48h',
        planBody:
          'Automatically prioritizes P1, P2, and P3 with suggested actions and validation criteria.',
        promptTitle: 'AI Correction Prompt',
        promptBody: 'Generates a ready-to-use prompt for:',
        diagramTitle: 'Flow diagram',
        diagramFlow:
          'Reports<br>↓<br>Analysis Engine<br>↓<br>Executive Report<br>↓<br>AI Prompt<br>↓<br>Developer',
        expectedTitle: 'Expected outcome',
        expectedBody:
          'The SDK automatically transforms beta feedback into actionable release decisions.',
      },
      aiPromptGuide: {
        title: 'Get the AI Fix Prompt',
        estimatedTimeLabel: 'Estimated time',
        estimatedTimeValue: '2 minutes',
        levelLabel: 'Level',
        levelValue: 'Beginner',
        step1: 'Run the export command.',
        step2: 'Open exports/demo/beta_summary.md.',
        step3: 'Find the "Prompt de Correccion" section.',
        step4: 'Copy it into Copilot, Cursor, ChatGPT or Gemini.',
        step5: 'Apply fixes by priority and run analyze/test.',
        commandTitle: 'Command',
        expectedTitle: 'Expected outcome',
        expectedBody:
          'You get a complete Executive Report and an AI-ready correction prompt.',
      },
      faqGuide: {
        title: 'FAQ',
        intro: 'Answers to the most common questions when integrating BetaTest Flow.',
        q1: {
          question: 'Do I need Firebase?',
          answer:
            'Firestore mode requires Firebase.<br>Offline JSON mode works without Firebase.',
        },
        q2: {
          question: 'Can I use BetaTest Flow completely offline?',
          answer:
            'Yes.<br>The SDK can export reports from JSON without connecting to Firestore.',
        },
        q3: {
          question: 'What does BetaTest Flow generate?',
          answer:
            'Executive Report<br>Release Decision<br>Beta Confidence Score<br>Action Plan 48h<br>AI Correction Prompt',
        },
        q4: {
          question: 'How do I get the AI Correction Prompt?',
          answer:
            'Run the export command,<br>open beta_summary.md,<br>copy the "Prompt de Correccion" section<br>and paste it into Copilot, ChatGPT, Cursor or Gemini.',
        },
        q5: {
          question: 'Can I customize the feedback form?',
          answer:
            'Yes.<br>Fields can be enabled or disabled through BetaTestFlowConfig.',
        },
        q6: {
          question: 'How can I contact the BetaTest Flow team?',
          answer: 'camiaaplicacion@gmail.com',
        },
      },
      executiveReport: {
        title: 'Executive Report Dashboard (Demo)',
        intro:
          'Live demo values generated from the official fixture sample_beta_reports.json.',
        source: 'Source fixture: example/data/sample_beta_reports.json (3 reports)',
        decision: {
          title: 'Release Decision',
          value: 'GO WITH CONDITIONS',
          reason:
            'Relevant risks remain; proceed only with mitigation and additional validation.',
        },
        score: {
          title: 'Beta Confidence Score',
          overall: '65/100 (Medium confidence)',
          stability: 'Stability: 80/100',
          usability: 'Usability: 80/100',
          readiness: 'Release readiness: 78/100',
        },
        topIssues: {
          title: 'Top Issues',
          issue1:
            '[tester_001] (high / failed) Publish button keeps loading and does not complete.',
        },
        actionPlan: {
          title: 'Action Plan 48h',
          p1: 'P1: Reduce high severity in main flow (PublishAlertScreen).',
          p2: 'P2: Stabilize most reported screen with guided scenarios.',
          p3:
            'P3: Mitigate high usage impact with UX/error feedback improvements.',
          p4: 'P4: Close release blockers with owners and ETA.',
          p5: 'P5: Resolve highlighted UX ambiguity in publish flow state.',
        },
        aiPrompt: {
          title: 'AI Correction Prompt (Preview)',
          preview:
            'Act as a senior engineer fixing a Flutter app using real beta feedback.\nDecision: GO WITH CONDITIONS\nBeta Confidence Score: 65/100\nPriority: P1 Publish flow high severity, then P2-P5 in 48h.',
        },
        metrics: {
          title: 'Report Metrics',
          intro:
            'Simple visual breakdown based on the official demo fixture values.',
          labels: {
            critical: 'Critical',
            high: 'High',
            medium: 'Medium',
            low: 'Low',
            workedWell: 'Worked Well',
            worked: 'Worked',
            needsImprovements: 'Needs Improvements',
            didntWork: "Didn't Work",
            yes: 'Yes',
            notYet: 'Not Yet',
            no: 'No',
          },
          severity: {
            title: 'Severity Distribution',
            description: 'Distribution of severity reported by testers.',
            total: 'Total analyzed: 3 reports',
          },
          result: {
            title: 'Result Distribution',
            description: 'How reports were classified by outcome.',
            total: 'Total analyzed: 3 reports',
          },
          publish: {
            title: 'Publish Recommendation',
            description: 'Recommendation trends from beta testers.',
            total: 'Total analyzed: 3 reports',
          },
          summary: {
            title: 'Report Summary',
            totalReportsLabel: 'Total reports:',
            totalReportsValue: '3',
            mostAffectedScreenLabel: 'Most affected screen:',
            mostAffectedScreenValue: 'PublishAlertScreen',
            highestSeverityLabel: 'Highest severity:',
            highestSeverityValue: 'High',
            releaseDecisionLabel: 'Release Decision:',
            releaseDecisionValue: 'GO WITH CONDITIONS',
            confidenceScoreLabel: 'Confidence Score:',
            confidenceScoreValue: '65/100 (Medium confidence)',
          },
        },
        timeline: {
          title: 'Executive Timeline',
          intro: 'Feedback -> Analysis -> Decision -> Action -> Prompt',
          completed: 'Completed',
          step1: {
            title: 'Reports received',
            description:
              'Beta reports were captured and consolidated from the campaign.',
          },
          step2: {
            title: 'Analysis completed',
            description:
              'The analysis engine processed severity, impact, and reproducibility.',
          },
          step3: {
            title: 'Release Decision',
            description:
              'A release state was determined with conditions for mitigation.',
          },
          step4: {
            title: 'Action Plan 48h',
            description:
              'Prioritized actions were prepared for the next 48 hours.',
          },
          step5: {
            title: 'AI Prompt generated',
            description:
              'A correction prompt was generated to accelerate implementation fixes.',
          },
          loop:
            'This is the complete BetaTest Flow loop: collect, analyze, decide and fix.',
        },
        actionPlanExpanded: {
          title: 'Action Plan 48h',
          intro: 'Prioritized fixes generated from tester feedback.',
          microcopy:
            'Start with P1. Do not refactor everything. Fix, validate, then move to the next priority.',
          labels: {
            reason: 'Reason:',
            action: 'Suggested action:',
            validation: 'Expected validation:',
          },
          p1: {
            title: 'Reduce high severity in main flow',
            reason:
              'There is one high severity report affecting functional stability.',
            action:
              'Prioritize fixes in frequent routes and reinforce error/retry handling.',
            validation:
              'Run smoke suite on core flows and verify no regressions.',
          },
          p2: {
            title: 'Stabilize most reported screen',
            reason:
              'PublishAlertScreen concentrates key reports and deserves early focus.',
            action:
              'Audit events, states and errors in PublishAlertScreen to reduce friction.',
            validation:
              'Run guided manual checks in PublishAlertScreen with at least 3 real scenarios.',
          },
          p3: {
            title: 'Mitigate high usage impact',
            reason:
              'There is one report indicating strong impact on usage continuity.',
            action:
              'Resolve flow/UX blockers and improve visual feedback in high-risk operations.',
            validation:
              'Compare before/after with beta testers and confirm perceived flow improvement.',
          },
          p4: {
            title: 'Close release decision gaps',
            reason:
              'There are release friction signals from tester recommendations.',
            action:
              'Convert non-release recommendations into a fix checklist with owners and ETA.',
            validation:
              'Re-run beta export and confirm reduction of negative recommendations.',
          },
          p5: {
            title: 'Address highlighted UX observation',
            reason:
              'The flow does not clearly indicate whether send failed or is still in progress.',
            action:
              'Apply targeted UX adjustment and document criteria for future consistency.',
            validation:
              'Validate with a quick qualitative test that users understand the improved state.',
          },
        },
        promptViewer: {
          title: 'AI Prompt Viewer',
          description:
            'Review the correction prompt before copying it into your AI coding assistant.',
          expand: 'Expand prompt',
          collapse: 'Collapse prompt',
          copy: 'Copy Prompt',
          copied: 'Prompt copied',
          promptText:
            'Act as a senior engineer fixing a Flutter app using real beta feedback.\n\nRelease Decision: GO WITH CONDITIONS\nBeta Confidence Score: 65/100 (Medium confidence)\n\n48h Plan priorities:\n- P1: Reduce high severity in main flow.\n- P2: Stabilize most reported screen.\n- P3: Mitigate high usage impact.\n- P4: Close release decision gaps.\n- P5: Address highlighted UX observation.\n\nMandatory constraints:\n- Do not do a general refactor.\n- Fix by 48h priority order.\n- Keep backwards compatibility.\n- Run analyze and tests at the end.\n\nExpected response format:\n1. Modified files.\n2. Cause.\n3. Solution.\n4. Validation (including analyze/tests).',
        },
        downloadOutputs: {
          title: 'Download Demo Outputs',
          downloadButton: 'Download',
          viewMarkdown: 'View Markdown',
          json: {
            title: 'JSON Report',
            description: 'Structured beta report data.',
          },
          csv: {
            title: 'CSV Report',
            description: 'Spreadsheet-friendly report export.',
          },
          markdown: {
            title: 'Markdown Summary',
            description:
              'Executive Report with decision, score, action plan and AI prompt.',
          },
        },
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
        tryDemo: 'Try the Demo',
        button: 'View on GitHub',
      },
      footer: {
        legal: 'BetaTest Flow SDK v0.1.0 | Legal: Privacy | Terms | License',
        contact: 'Official contact: camiaaplicacion@gmail.com',
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
        ctaTryDemo: 'Probar la demo',
        ctaDemo: 'Ver Reporte Demo',
      },
      nav: {
        documentation: 'Documentacion',
      },
      shared: {
        getAiPromptCta: 'Obtener prompt IA',
      },
      share: {
        hero: 'Compartir',
        cta: 'Compartir BetaTest Flow',
        copied: 'Enlace copiado',
        title: 'BetaTest Flow',
        text:
          'SDK Flutter para beta testing: recopila feedback, analiza resultados y publica con confianza.',
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
      documentation: {
        title: 'Documentacion',
        intro:
          'Construye tu ruta de integracion paso a paso. Empieza rapido y luego profundiza en exportacion y analisis.',
        estimatedTime: 'Tiempo estimado',
        level: 'Nivel',
        comingNext: 'Proximamente',
        readGuide: 'Leer guia',
        gettingStarted: {
          title: 'Primeros pasos',
          description:
            'Entiende el flujo base y la configuracion minima para comenzar a recolectar feedback beta.',
          time: '5 min',
          level: 'Beginner',
        },
        installation: {
          title: 'Instalacion',
          description:
            'Configura la dependencia, sincroniza paquetes y prepara el entorno de la app host.',
          time: '8 min',
          level: 'Beginner',
        },
        firstReport: {
          title: 'Primer reporte beta',
          description:
            'Crea tu primer reporte completo y valida el flujo de captura de punta a punta.',
          time: '10 min',
          level: 'Beginner',
        },
        exportReports: {
          title: 'Exportar reportes',
          description:
            'Genera salidas JSON, CSV y markdown desde Firestore o fixtures offline.',
          time: '5 min',
          level: 'Intermediate',
        },
        analysisEngine: {
          title: 'Analysis Engine',
          description:
            'Interpreta decision de release, confidence score y prioridades del plan 48h.',
          time: '5 min',
          level: 'Intermediate',
        },
        faq: {
          title: 'FAQ',
          description:
            'Resuelve rapidamente dudas comunes de integracion y troubleshooting.',
          time: '7 min',
          level: 'Advanced',
        },
      },
      gettingStarted: {
        title: 'Primeros pasos',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '5 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Beginner',
        learnTitle: 'Que aprenderas',
        learnBody:
          'Entenderas la ruta minima de integracion, cuando ejecutar exportaciones y como usar el analisis para publicar con confianza.',
        whatIsTitle: 'Que es BetaTest Flow',
        whatIsBody:
          'BetaTest Flow es un SDK Flutter reutilizable para capturar feedback beta estructurado y convertirlo en guia accionable para release.',
        whenToUseTitle: 'Cuando usarlo',
        whenToUseBody:
          'Usalo cuando tu equipo necesite un proceso beta repetible, criterios claros de release y ciclos mas rapidos de feedback a correccion.',
        flowTitle: 'Flujo completo',
        flowLine:
          'Flutter App -> SDK Widget -> Firestore/JSON -> Analysis Engine -> Executive Report -> AI Correction Prompt',
        expectedTitle: 'Resultado esperado',
        expectedBody:
          'Al final, tendras un pipeline de reportes estructurado y una ruta clara de accion para decidir release y correcciones.',
      },
      installationGuide: {
        title: 'Instalacion',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '5 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Beginner',
        requirementsTitle: 'Requisitos',
        req1: 'Flutter >= 3.35.0',
        req2: 'Proyecto Firebase si usas modo Firestore',
        req3: 'Modo JSON offline disponible sin Firebase',
        dependencyTitle: 'Instalar dependencia',
        importTitle: 'Importar SDK',
        firstButtonTitle: 'Agregar primer boton',
        expectedTitle: 'Resultado esperado',
        expectedBody:
          'Un boton de feedback visible en tu app y listo para capturar reportes beta.',
      },
      firstReportGuide: {
        title: 'Primer reporte beta',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '10 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Beginner',
        flowTitle: 'Flujo',
        step1: 'Agregar BetaFeedbackButton',
        step2: 'Tester envia feedback',
        step3: 'El reporte se guarda',
        step4: 'Exportar reportes',
        step5: 'Generar Executive Report',
        expectedTitle: 'Resultado esperado',
        expectedBody: 'Primer reporte beta estructurado listo para analisis.',
      },
      exportReportsGuide: {
        title: 'Exportar reportes',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '5 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Intermediate',
        modesTitle: 'Modos de exportacion',
        modeA: 'A) Modo Firestore',
        modeB: 'B) Modo JSON offline',
        offlineCommandTitle: 'Comando offline',
        outputsTitle: 'Salidas generadas',
        expectedTitle: 'Resultado esperado',
        expectedBody: 'Executive Report generado localmente sin Firebase.',
      },
      analysisEngineGuide: {
        title: 'Analysis Engine',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '5 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Intermediate',
        intro:
          'El motor analiza automaticamente todos los reportes beta y genera informacion accionable para el equipo de desarrollo.',
        decisionTitle: 'Release Decision',
        decisionBody: 'Clasifica automaticamente el estado de release como:',
        scoreTitle: 'Beta Confidence Score',
        scoreBody: 'Genera las siguientes dimensiones de score:',
        planTitle: 'Action Plan 48h',
        planBody:
          'Prioriza automaticamente P1, P2 y P3 con acciones sugeridas y criterios de validacion.',
        promptTitle: 'AI Correction Prompt',
        promptBody: 'Genera un prompt listo para usar con:',
        diagramTitle: 'Diagrama de flujo',
        diagramFlow:
          'Reportes<br>↓<br>Analysis Engine<br>↓<br>Executive Report<br>↓<br>AI Prompt<br>↓<br>Developer',
        expectedTitle: 'Resultado esperado',
        expectedBody:
          'El SDK transforma automaticamente el feedback beta en decisiones de release accionables.',
      },
      aiPromptGuide: {
        title: 'Obtener el prompt de correccion IA',
        estimatedTimeLabel: 'Tiempo estimado',
        estimatedTimeValue: '2 minutos',
        levelLabel: 'Nivel',
        levelValue: 'Principiante',
        step1: 'Ejecuta el comando de exportacion.',
        step2: 'Abre exports/demo/beta_summary.md.',
        step3: 'Encuentra la seccion "Prompt de Correccion".',
        step4: 'Copialo en Copilot, Cursor, ChatGPT o Gemini.',
        step5: 'Aplica correcciones por prioridad y ejecuta analyze/test.',
        commandTitle: 'Comando',
        expectedTitle: 'Resultado esperado',
        expectedBody:
          'Obtienes un Executive Report completo y un prompt de correccion listo para IA.',
      },
      faqGuide: {
        title: 'FAQ',
        intro:
          'Respuestas a las preguntas mas frecuentes al integrar BetaTest Flow.',
        q1: {
          question: '¿Necesito Firebase?',
          answer:
            'El modo Firestore requiere Firebase.<br>El modo JSON offline funciona sin Firebase.',
        },
        q2: {
          question: '¿Puedo usar BetaTest Flow completamente offline?',
          answer:
            'Si.<br>El SDK puede exportar reportes desde JSON sin conectarse a Firestore.',
        },
        q3: {
          question: '¿Que genera BetaTest Flow?',
          answer:
            'Executive Report<br>Release Decision<br>Beta Confidence Score<br>Action Plan 48h<br>AI Correction Prompt',
        },
        q4: {
          question: '¿Como obtengo el prompt de correccion IA?',
          answer:
            'Ejecuta el comando de exportacion,<br>abre beta_summary.md,<br>copia la seccion "Prompt de Correccion"<br>y pegalo en Copilot, ChatGPT, Cursor o Gemini.',
        },
        q5: {
          question: '¿Puedo personalizar el formulario de feedback?',
          answer:
            'Si.<br>Los campos pueden habilitarse o deshabilitarse mediante BetaTestFlowConfig.',
        },
        q6: {
          question: '¿Como puedo contactar al equipo de BetaTest Flow?',
          answer: 'camiaaplicacion@gmail.com',
        },
      },
      executiveReport: {
        title: 'Dashboard Executive Report (Demo)',
        intro:
          'Valores de demo generados desde el fixture oficial sample_beta_reports.json.',
        source:
          'Fixture fuente: example/data/sample_beta_reports.json (3 reportes)',
        decision: {
          title: 'Release Decision',
          value: 'GO CON CONDICIONES',
          reason:
            'Existen riesgos relevantes; avanzar solo con mitigacion y validacion adicional.',
        },
        score: {
          title: 'Beta Confidence Score',
          overall: '65/100 (Confianza media)',
          stability: 'Estabilidad: 80/100',
          usability: 'Usabilidad: 80/100',
          readiness: 'Release readiness: 78/100',
        },
        topIssues: {
          title: 'Top Issues',
          issue1:
            '[tester_001] (alta / no_funciono) El boton de publicar se queda cargando y no completa la accion.',
        },
        actionPlan: {
          title: 'Action Plan 48h',
          p1: 'P1: Reducir severidad alta en flujo principal (PublishAlertScreen).',
          p2: 'P2: Estabilizar pantalla mas reportada con escenarios guiados.',
          p3:
            'P3: Mitigar impacto fuerte de uso con mejoras UX/feedback de error.',
          p4: 'P4: Cerrar bloqueadores de release con responsables y ETA.',
          p5: 'P5: Resolver ambiguedad UX destacada en estado de publicacion.',
        },
        aiPrompt: {
          title: 'AI Correction Prompt (Vista previa)',
          preview:
            'Actua como un ingeniero senior corrigiendo una app Flutter basada en feedback beta real.\nDecision: GO CON CONDICIONES\nBeta Confidence Score: 65/100\nPrioridad: P1 flujo de publicacion en severidad alta, luego P2-P5 en 48h.',
        },
        metrics: {
          title: 'Metricas del Reporte',
          intro:
            'Desglose visual simple basado en los valores del fixture oficial de demo.',
          labels: {
            critical: 'Critica',
            high: 'Alta',
            medium: 'Media',
            low: 'Baja',
            workedWell: 'Funciono muy bien',
            worked: 'Funciono',
            needsImprovements: 'Necesita mejoras',
            didntWork: 'No funciono',
            yes: 'Si',
            notYet: 'No todavia',
            no: 'No',
          },
          severity: {
            title: 'Distribucion por severidad',
            description: 'Distribucion de severidad reportada por testers.',
            total: 'Total analizado: 3 reportes',
          },
          result: {
            title: 'Distribucion de resultados',
            description: 'Como se clasificaron los reportes por resultado.',
            total: 'Total analizado: 3 reportes',
          },
          publish: {
            title: 'Recomendacion de publicacion',
            description: 'Tendencia de recomendacion de los testers beta.',
            total: 'Total analizado: 3 reportes',
          },
          summary: {
            title: 'Resumen del reporte',
            totalReportsLabel: 'Reportes totales:',
            totalReportsValue: '3',
            mostAffectedScreenLabel: 'Pantalla mas afectada:',
            mostAffectedScreenValue: 'PublishAlertScreen',
            highestSeverityLabel: 'Mayor severidad:',
            highestSeverityValue: 'Alta',
            releaseDecisionLabel: 'Release Decision:',
            releaseDecisionValue: 'GO CON CONDICIONES',
            confidenceScoreLabel: 'Confidence Score:',
            confidenceScoreValue: '65/100 (Confianza media)',
          },
        },
        timeline: {
          title: 'Linea de tiempo ejecutiva',
          intro: 'Feedback -> Analisis -> Decision -> Accion -> Prompt',
          completed: 'Completado',
          step1: {
            title: 'Reportes recibidos',
            description:
              'Los reportes beta fueron capturados y consolidados desde la campana.',
          },
          step2: {
            title: 'Analisis completado',
            description:
              'El motor de analisis proceso severidad, impacto y repetibilidad.',
          },
          step3: {
            title: 'Decision de publicacion',
            description:
              'Se determino el estado de release con condiciones de mitigacion.',
          },
          step4: {
            title: 'Plan de accion 48h',
            description:
              'Se definieron acciones priorizadas para las proximas 48 horas.',
          },
          step5: {
            title: 'Prompt IA generado',
            description:
              'Se genero un prompt de correccion para acelerar la implementacion de fixes.',
          },
          loop:
            'Este es el ciclo completo de BetaTest Flow: recopilar, analizar, decidir y corregir.',
        },
        actionPlanExpanded: {
          title: 'Plan de accion 48h',
          intro:
            'Correcciones priorizadas generadas desde el feedback de testers.',
          microcopy:
            'Comienza por P1. No refactorices todo. Corrige, valida y luego avanza a la siguiente prioridad.',
          labels: {
            reason: 'Razon:',
            action: 'Accion sugerida:',
            validation: 'Validacion esperada:',
          },
          p1: {
            title: 'Reducir severidad alta en flujo principal',
            reason:
              'Hay un reporte de severidad alta que afecta la estabilidad funcional.',
            action:
              'Prioriza fixes en rutas frecuentes y refuerza manejo de error/reintento.',
            validation:
              'Ejecuta smoke suite en flujos clave y verifica ausencia de regresiones.',
          },
          p2: {
            title: 'Estabilizar pantalla mas reportada',
            reason:
              'PublishAlertScreen concentra reportes clave y merece foco temprano.',
            action:
              'Audita eventos, estados y errores en PublishAlertScreen para reducir friccion.',
            validation:
              'Corre validaciones manuales guiadas en PublishAlertScreen con al menos 3 escenarios reales.',
          },
          p3: {
            title: 'Mitigar impacto fuerte de uso',
            reason:
              'Existe un reporte que indica alto impacto en continuidad de uso.',
            action:
              'Resuelve bloqueos de flujo/UX y mejora feedback visual en operaciones de alto riesgo.',
            validation:
              'Compara antes/despues con testers beta y confirma mejora percibida del flujo.',
          },
          p4: {
            title: 'Cerrar brechas de decision de release',
            reason:
              'Hay senales de friccion de release en las recomendaciones de testers.',
            action:
              'Convierte recomendaciones de no-release en checklist de fixes con responsables y ETA.',
            validation:
              'Repite export beta y confirma reduccion de recomendaciones negativas.',
          },
          p5: {
            title: 'Atender observacion UX destacada',
            reason:
              'El flujo no indica claramente si el envio fallo o sigue en progreso.',
            action:
              'Aplica ajuste UX puntual y documenta criterio para consistencia futura.',
            validation:
              'Valida con una prueba cualitativa rapida que se entienda el nuevo estado.',
          },
        },
        promptViewer: {
          title: 'Visor de Prompt IA',
          description:
            'Revisa el prompt de correccion antes de copiarlo en tu asistente de codigo IA.',
          expand: 'Expandir prompt',
          collapse: 'Contraer prompt',
          copy: 'Copiar prompt',
          copied: 'Prompt copiado',
          promptText:
            'Actua como un ingeniero senior corrigiendo una app Flutter basada en feedback beta real.\n\nDecision de publicacion: GO CON CONDICIONES\nBeta Confidence Score: 65/100 (Confianza media)\n\nPrioridades del plan 48h:\n- P1: Reducir severidad alta en flujo principal.\n- P2: Estabilizar pantalla mas reportada.\n- P3: Mitigar impacto fuerte de uso.\n- P4: Cerrar brechas de decision de release.\n- P5: Atender observacion UX destacada.\n\nRestricciones obligatorias:\n- No hacer refactor general.\n- Corregir por orden de prioridad 48h.\n- Mantener compatibilidad hacia atras.\n- Ejecutar analyze y tests al final.\n\nFormato esperado de respuesta:\n1. Archivos modificados.\n2. Causa.\n3. Solucion.\n4. Validacion (incluye analyze/tests).',
        },
        downloadOutputs: {
          title: 'Descargar salidas demo',
          downloadButton: 'Descargar',
          viewMarkdown: 'Ver Markdown',
          json: {
            title: 'Reporte JSON',
            description: 'Datos estructurados de reportes beta.',
          },
          csv: {
            title: 'Reporte CSV',
            description: 'Exportacion de reportes para hojas de calculo.',
          },
          markdown: {
            title: 'Resumen Markdown',
            description:
              'Executive Report con decision, score, plan de accion y prompt IA.',
          },
        },
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
        tryDemo: 'Probar la demo',
        button: 'Ver en GitHub',
      },
      footer: {
        legal: 'BetaTest Flow SDK v0.1.0 | Legal: Privacidad | Terminos | Licencia',
        contact: 'Contacto oficial: camiaaplicacion@gmail.com',
      },
    },
  };

  function getValue(obj, key) {
    return key.split('.').reduce((acc, part) => (acc && acc[part] !== undefined ? acc[part] : null), obj);
  }

  function applyLanguage(lang) {
    const dictionary = translations[lang] || translations.en;
    currentLang = lang;

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

    syncAiPromptViewerState();

    localStorage.setItem(STORAGE_KEY, lang);
  }

  function getShareDictionary() {
    return translations[currentLang] || translations.en;
  }

  async function copyToClipboard(text) {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(text);
        return true;
      }
    } catch (_) {
      // Fallback below.
    }

    try {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.setAttribute('readonly', '');
      textarea.style.position = 'absolute';
      textarea.style.left = '-9999px';
      document.body.appendChild(textarea);
      textarea.select();
      const ok = document.execCommand('copy');
      document.body.removeChild(textarea);
      return ok;
    } catch (_) {
      return false;
    }
  }

  function showShareFeedback(button, text) {
    const original = button.textContent;
    button.textContent = text;
    button.classList.add('is-success');

    window.setTimeout(() => {
      const key = button.getAttribute('data-i18n');
      const dictionary = getShareDictionary();
      const translated = key ? getValue(dictionary, key) : null;
      button.textContent = typeof translated === 'string' ? translated : original;
      button.classList.remove('is-success');
    }, 1400);
  }

  async function handleShareClick(button) {
    const dictionary = getShareDictionary();
    const shareData = {
      title: dictionary.share.title,
      text: dictionary.share.text,
      url: window.location.href,
    };

    let completed = false;
    if (typeof navigator.share === 'function') {
      try {
        await navigator.share(shareData);
        completed = true;
      } catch (error) {
        if (error && error.name === 'AbortError') {
          return;
        }
      }
    }

    if (!completed) {
      const copied = await copyToClipboard(shareData.url);
      if (!copied) {
        return;
      }
    }

    showShareFeedback(button, dictionary.share.copied);
  }

  function setFaqState(button, expanded) {
    const panelId = button.getAttribute('aria-controls');
    const panel = panelId ? document.getElementById(panelId) : null;
    button.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    if (panel) {
      panel.hidden = !expanded;
    }
  }

  function setupFaqAccordion() {
    const questions = Array.from(document.querySelectorAll('[data-faq-question]'));
    if (questions.length === 0) {
      return;
    }

    questions.forEach((button) => {
      setFaqState(button, false);
      button.addEventListener('click', () => {
        const isExpanded = button.getAttribute('aria-expanded') === 'true';
        questions.forEach((otherButton) => {
          if (otherButton !== button) {
            setFaqState(otherButton, false);
          }
        });
        setFaqState(button, !isExpanded);
      });
    });
  }

  function setActionPlanState(button, expanded) {
    const panelId = button.getAttribute('aria-controls');
    const panel = panelId ? document.getElementById(panelId) : null;
    button.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    if (panel) {
      panel.hidden = !expanded;
    }
  }

  function setupActionPlanAccordion() {
    const triggers = Array.from(
      document.querySelectorAll('[data-action-plan-trigger]'),
    );
    if (triggers.length === 0) {
      return;
    }

    triggers.forEach((button) => {
      setActionPlanState(button, false);
      button.addEventListener('click', () => {
        const isExpanded = button.getAttribute('aria-expanded') === 'true';
        triggers.forEach((otherButton) => {
          if (otherButton !== button) {
            setActionPlanState(otherButton, false);
          }
        });
        setActionPlanState(button, !isExpanded);
      });
    });
  }

  function syncAiPromptViewerState() {
    const toggleButton = document.querySelector('[data-ai-prompt-toggle]');
    if (!toggleButton) {
      return;
    }

    const dictionary = translations[currentLang] || translations.en;
    const expanded = toggleButton.getAttribute('aria-expanded') === 'true';
    toggleButton.textContent = expanded
      ? dictionary.executiveReport.promptViewer.collapse
      : dictionary.executiveReport.promptViewer.expand;
  }

  function setupAiPromptViewer() {
    const toggleButton = document.querySelector('[data-ai-prompt-toggle]');
    const copyButton = document.querySelector('[data-ai-prompt-copy]');
    const preview = document.querySelector('[data-ai-prompt-preview]');
    const promptCode = preview ? preview.querySelector('code') : null;

    if (!toggleButton || !copyButton || !preview || !promptCode) {
      return;
    }

    toggleButton.addEventListener('click', () => {
      const expanded = toggleButton.getAttribute('aria-expanded') === 'true';
      const nextExpanded = !expanded;
      toggleButton.setAttribute('aria-expanded', nextExpanded ? 'true' : 'false');
      preview.classList.toggle('is-collapsed', !nextExpanded);
      syncAiPromptViewerState();
    });

    copyButton.addEventListener('click', async () => {
      const dictionary = translations[currentLang] || translations.en;
      const copied = await copyToClipboard(promptCode.textContent || '');
      if (!copied) {
        return;
      }

      copyButton.textContent = dictionary.executiveReport.promptViewer.copied;
      copyButton.classList.add('is-success');
      window.setTimeout(() => {
        const fallbackDictionary = translations[currentLang] || translations.en;
        copyButton.textContent = fallbackDictionary.executiveReport.promptViewer.copy;
        copyButton.classList.remove('is-success');
      }, 1400);
    });

    preview.classList.add('is-collapsed');
    toggleButton.setAttribute('aria-expanded', 'false');
    syncAiPromptViewerState();
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

  document.querySelectorAll('[data-share-trigger]').forEach((button) => {
    button.addEventListener('click', () => {
      handleShareClick(button);
    });
  });

  setupFaqAccordion();
  setupActionPlanAccordion();
  setupAiPromptViewer();
})();
