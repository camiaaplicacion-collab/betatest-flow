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
        home: 'Home',
        integrate: 'Integrate',
        documentation: 'Documentation',
        demo: 'Demo',
        roadmap: 'Roadmap',
        github: 'GitHub',
      },
      shared: {
        getAiPromptCta: 'Get AI Fix Prompt',
      },
      a11y: {
        expanded: 'expanded',
        collapsed: 'collapsed',
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
      integrationGuide: {
        title: 'Integration Guide',
        intro:
          'Follow these 7 steps to install and integrate BetaTest Flow end to end.',
        expectedLabel: 'Expected:',
        copyButton: 'Copy code',
        copied: 'Copied',
        step1: {
          title: 'Install the SDK',
          description:
            'Add BetaTest Flow as a local dependency in your Flutter project.',
          expected: 'The dependency is resolved and ready to import.',
        },
        step2: {
          title: 'Import the package',
          description:
            'Import BetaTest Flow in the file where you will configure the SDK.',
          expected:
            'You can access BetaTest Flow classes from your app code.',
        },
        step3: {
          title: 'Create the config',
          description:
            'Define app, campaign and user context for report attribution.',
          expected:
            'Configuration object is ready to be injected into UI components.',
        },
        step4: {
          title: 'Add the feedback button',
          description:
            'Render the SDK button so testers can submit structured feedback.',
          expected: 'Feedback entry point is visible in your app UI.',
        },
        step5: {
          title: 'Send your first beta report',
          description:
            'Run your app, open the feedback button and submit a structured report.',
          expected:
            'One report is generated with severity, result and recommendation fields.',
        },
        step6: {
          title: 'Export reports',
          description:
            'Generate demo outputs from the official sample fixture.',
          expected:
            'JSON, CSV and Markdown reports are generated under exports/demo.',
        },
        step7: {
          title: 'Use the AI prompt',
          description:
            'Open exports/demo/beta_summary.md and copy the AI Correction Prompt into Copilot, Cursor, ChatGPT or Gemini.',
          expected:
            'You have a ready-to-run prompt grounded in real beta evidence.',
        },
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
        demoStatus: {
          loaded: 'Demo data loaded from beta_reports.json',
          fallback: 'Using embedded fallback demo data',
        },
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
        liveReportExplorer: {
          title: 'Live Report Explorer',
          intro:
            'Inspect the individual reports behind the Executive Report.',
          noReports: 'No reports available for this demo.',
          labels: {
            tester: 'Tester',
            screen: 'Screen',
            severity: 'Severity',
            result: 'Result',
            publishRecommendation: 'Publish Recommendation',
            feedback: 'Feedback',
            steps: 'Steps to Reproduce',
            suggestion: 'Suggestion',
            uxDetails: 'UX Details',
            markdownPreview: 'Markdown Preview',
          },
          expand: 'Expand report',
          collapse: 'Collapse report',
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
        home: 'Inicio',
        integrate: 'Integrar',
        documentation: 'Documentacion',
        demo: 'Demo',
        roadmap: 'Roadmap',
        github: 'GitHub',
      },
      shared: {
        getAiPromptCta: 'Obtener prompt IA',
      },
      a11y: {
        expanded: 'expandido',
        collapsed: 'contraido',
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
      integrationGuide: {
        title: 'Guia de integracion',
        intro:
          'Sigue estos 7 pasos para instalar e integrar BetaTest Flow de punta a punta.',
        expectedLabel: 'Resultado esperado:',
        copyButton: 'Copiar codigo',
        copied: 'Copiado',
        step1: {
          title: 'Instalar el SDK',
          description:
            'Agrega BetaTest Flow como dependencia local en tu proyecto Flutter.',
          expected: 'La dependencia queda resuelta y lista para importar.',
        },
        step2: {
          title: 'Importar el paquete',
          description:
            'Importa BetaTest Flow en el archivo donde configuraras el SDK.',
          expected:
            'Ya puedes acceder a las clases de BetaTest Flow desde tu app.',
        },
        step3: {
          title: 'Crear la configuracion',
          description:
            'Define app, campana y usuario para atribuir correctamente los reportes.',
          expected:
            'El objeto de configuracion queda listo para inyectarse en UI.',
        },
        step4: {
          title: 'Agregar el boton de feedback',
          description:
            'Renderiza el boton del SDK para que testers envien feedback estructurado.',
          expected: 'El punto de entrada de feedback ya es visible en la app.',
        },
        step5: {
          title: 'Enviar tu primer reporte beta',
          description:
            'Ejecuta tu app, abre el boton de feedback y envia un reporte estructurado.',
          expected:
            'Se genera un reporte con severidad, resultado y recomendacion.',
        },
        step6: {
          title: 'Exportar reportes',
          description:
            'Genera salidas demo usando el fixture oficial de ejemplo.',
          expected:
            'Se generan reportes JSON, CSV y Markdown en exports/demo.',
        },
        step7: {
          title: 'Usar el prompt IA',
          description:
            'Abre exports/demo/beta_summary.md y copia el AI Correction Prompt en Copilot, Cursor, ChatGPT o Gemini.',
          expected:
            'Tienes un prompt listo para ejecutar, basado en evidencia real beta.',
        },
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
        demoStatus: {
          loaded: 'Datos demo cargados desde beta_reports.json',
          fallback: 'Usando datos demo internos de respaldo',
        },
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
        liveReportExplorer: {
          title: 'Explorador de reportes en vivo',
          intro:
            'Inspecciona los reportes individuales detras del Executive Report.',
          noReports: 'No hay reportes disponibles para esta demo.',
          labels: {
            tester: 'Tester',
            screen: 'Pantalla',
            severity: 'Severidad',
            result: 'Resultado',
            publishRecommendation: 'Recomendacion de publicacion',
            feedback: 'Feedback',
            steps: 'Pasos para reproducir',
            suggestion: 'Sugerencia',
            uxDetails: 'Detalles UX',
            markdownPreview: 'Vista previa markdown',
          },
          expand: 'Expandir reporte',
          collapse: 'Contraer reporte',
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

  const fallbackDemoStats = {
    totalReports: 3,
    severity: { critical: 0, high: 1, medium: 1, low: 1 },
    result: { workedWell: 1, worked: 0, needsImprovements: 1, didntWork: 1 },
    publish: { yes: 2, notYet: 1, no: 0 },
    mostAffectedScreen: 'PublishAlertScreen',
    highestSeverity: 'high',
    releaseDecision: 'GO WITH CONDITIONS',
    confidence: { overall: 65, level: 'medium', stability: 80, usability: 80, readiness: 78 },
    topIssue: {
      userId: 'tester_001',
      severity: 'high',
      result: 'didntWork',
      feedbackText:
        'Publish button keeps loading and does not complete.',
    },
  };

  const fallbackDemoReports = [
    {
      userId: 'tester_001',
      email: 'qa1@buskia.com',
      screenName: 'PublishAlertScreen',
      severity: 'alta',
      result: 'no_funciono',
      publishRecommendation: 'No todavia',
      feedbackText:
        'El boton de publicar se queda cargando y no completa la accion.',
      stepsToReproduce:
        '1. Iniciar sesion. 2. Ir a Publicar alerta. 3. Completar formulario. 4. Presionar Publicar.',
      suggestion:
        'Mostrar mensaje de error con causa y habilitar reintento automatico.',
      uxDetails:
        'El flujo no indica claramente si el envio fallo o sigue en progreso.',
      markdownReport: '# Reporte\n- Problema al publicar alerta\n- Severidad alta',
    },
    {
      userId: 'tester_002',
      email: 'qa2@buskia.com',
      screenName: 'HomeScreen',
      severity: 'media',
      result: 'funciono_a_medias',
      publishRecommendation: 'Si, con ajustes menores',
      feedbackText:
        'La pantalla principal carga, pero los filtros tardan demasiado en aplicar.',
      stepsToReproduce:
        '1. Abrir app. 2. Entrar a Home. 3. Cambiar filtro por categoria.',
      suggestion: 'Cachear resultados iniciales y reducir consultas duplicadas.',
      uxDetails:
        'El indicador de carga ayuda, pero no muestra tiempo estimado.',
      markdownReport: '# Reporte\n- Lentitud en filtros\n- Impacto medio',
    },
    {
      userId: 'tester_003',
      email: 'qa3@buskia.com',
      screenName: 'AuthScreen',
      severity: 'baja',
      result: 'funciono',
      publishRecommendation: 'Si',
      feedbackText:
        'Registro y login correctos; sugerencia menor en textos de ayuda.',
      stepsToReproduce:
        '1. Crear cuenta nueva. 2. Confirmar correo. 3. Iniciar sesion.',
      suggestion:
        'Simplificar el texto del tooltip en campo de contrasena.',
      uxDetails: 'El flujo es claro y rapido en dispositivos actuales.',
      markdownReport:
        '# Reporte\n- Flujo de autenticacion estable\n- Ajuste menor recomendado',
    },
  ];

  let demoReportStats = null;
  let demoReportItems = [];
  let demoReportSource = 'fallback';

  function setText(selector, value) {
    const element = document.querySelector(selector);
    if (element && typeof value === 'string') {
      element.textContent = value;
    }
  }

  function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value));
  }

  function setBar(selector, count, total) {
    const element = document.querySelector(selector);
    if (!element) {
      return;
    }
    const percentage = total > 0 ? (count / total) * 100 : 0;
    element.style.setProperty('--bar-value', `${percentage.toFixed(2)}%`);
  }

  function getSeverityKey(rawSeverity) {
    const value = String(rawSeverity || '').trim().toLowerCase();
    if (value === 'critica' || value === 'crtica' || value === 'critical') {
      return 'critical';
    }
    if (value === 'alta' || value === 'high') {
      return 'high';
    }
    if (value === 'media' || value === 'medium') {
      return 'medium';
    }
    return 'low';
  }

  function getResultKey(rawResult) {
    const value = String(rawResult || '').trim().toLowerCase();
    if (value === 'no_funciono' || value === 'no funciono' || value === 'failed') {
      return 'didntWork';
    }
    if (value === 'funciono_a_medias' || value === 'partial' || value === 'partial_success') {
      return 'needsImprovements';
    }
    if (value === 'funciono' || value === 'worked_well') {
      return 'workedWell';
    }
    return 'worked';
  }

  function getPublishKey(rawRecommendation) {
    const value = String(rawRecommendation || '').trim().toLowerCase();
    if (value === 'no' || value === 'dont_publish' || value === 'do_not_publish') {
      return 'no';
    }
    if (value.includes('no todavia') || value.includes('not yet') || value === 'later') {
      return 'notYet';
    }
    return 'yes';
  }

  function pickHighestSeverity(severityDistribution) {
    if (severityDistribution.critical > 0) {
      return 'critical';
    }
    if (severityDistribution.high > 0) {
      return 'high';
    }
    if (severityDistribution.medium > 0) {
      return 'medium';
    }
    return 'low';
  }

  function computeReleaseDecision(severityDistribution, publishDistribution) {
    if (severityDistribution.critical > 0 || publishDistribution.no > 0) {
      return 'NO-GO';
    }
    if (severityDistribution.high > 0 || publishDistribution.notYet > 0) {
      return 'GO WITH CONDITIONS';
    }
    return 'GO';
  }

  function computeConfidence(totalReports, severityDistribution, resultDistribution, publishDistribution) {
    const overallPenalty =
      severityDistribution.critical * 28 +
      severityDistribution.high * 15 +
      resultDistribution.didntWork * 10 +
      publishDistribution.notYet * 7 +
      publishDistribution.no * 15;
    const overall = clamp(Math.round(100 - overallPenalty), 0, 100);

    const stability = clamp(
      Math.round(100 - severityDistribution.critical * 30 - severityDistribution.high * 20),
      0,
      100,
    );

    const usability = clamp(
      Math.round(100 - (resultDistribution.needsImprovements + resultDistribution.didntWork) * 10),
      0,
      100,
    );

    const publishReadinessBase = totalReports > 0
      ? ((publishDistribution.yes + publishDistribution.notYet * 0.5) / totalReports) * 100
      : 0;
    const readiness = clamp(Math.round(publishReadinessBase - severityDistribution.high * 5), 0, 100);

    let level = 'low';
    if (overall >= 75) {
      level = 'high';
    } else if (overall >= 50) {
      level = 'medium';
    }

    return {
      overall,
      level,
      stability,
      usability,
      readiness,
    };
  }

  function getMostAffectedScreen(screenCount) {
    const entries = Object.entries(screenCount);
    if (entries.length === 0) {
      return 'N/A';
    }
    entries.sort((a, b) => b[1] - a[1]);
    return entries[0][0];
  }

  function computeDemoStats(reports) {
    if (!Array.isArray(reports) || reports.length === 0) {
      return { ...fallbackDemoStats };
    }

    const severity = { critical: 0, high: 0, medium: 0, low: 0 };
    const result = { workedWell: 0, worked: 0, needsImprovements: 0, didntWork: 0 };
    const publish = { yes: 0, notYet: 0, no: 0 };
    const screenCount = {};

    let topIssue = null;
    const severityRank = { low: 1, medium: 2, high: 3, critical: 4 };

    reports.forEach((report) => {
      const severityKey = getSeverityKey(report && report.severity);
      const resultKey = getResultKey(report && report.result);
      const publishKey = getPublishKey(report && report.publishRecommendation);

      severity[severityKey] += 1;
      result[resultKey] += 1;
      publish[publishKey] += 1;

      const rawScreen = String((report && report.screenName) || '').trim();
      if (rawScreen) {
        screenCount[rawScreen] = (screenCount[rawScreen] || 0) + 1;
      }

      const candidate = {
        userId: String((report && report.userId) || 'tester_unknown'),
        severity: severityKey,
        result: resultKey,
        feedbackText: String((report && report.feedbackText) || '').trim(),
      };

      const currentRank = topIssue ? severityRank[topIssue.severity] : 0;
      const candidateRank = severityRank[candidate.severity] || 0;
      if (!topIssue || candidateRank > currentRank) {
        topIssue = candidate;
      }
    });

    const totalReports = reports.length;
    const highestSeverity = pickHighestSeverity(severity);
    const releaseDecision = computeReleaseDecision(severity, publish);
    const confidence = computeConfidence(totalReports, severity, result, publish);

    return {
      totalReports,
      severity,
      result,
      publish,
      mostAffectedScreen: getMostAffectedScreen(screenCount),
      highestSeverity,
      releaseDecision,
      confidence,
      topIssue: topIssue || fallbackDemoStats.topIssue,
    };
  }

  function getDecisionText(lang, decision) {
    if (lang === 'es') {
      if (decision === 'NO-GO') {
        return 'NO-GO';
      }
      if (decision === 'GO') {
        return 'GO';
      }
      return 'GO CON CONDICIONES';
    }
    return decision;
  }

  function getDecisionReason(lang, decision, highestSeverity) {
    if (lang === 'es') {
      if (decision === 'NO-GO') {
        return 'Se detectaron riesgos criticos o recomendacion de no publicar; cerrar bloqueadores antes de release.';
      }
      if (decision === 'GO') {
        return 'No se observan bloqueadores relevantes; proceder y monitorear con checks post-release.';
      }
      return `Persisten riesgos de severidad ${highestSeverity}; avanzar solo con mitigaciones y validacion adicional.`;
    }

    if (decision === 'NO-GO') {
      return 'Critical risks or do-not-publish recommendations were found; close blockers before release.';
    }
    if (decision === 'GO') {
      return 'No relevant release blockers detected; proceed and monitor with post-release checks.';
    }
    return `Relevant ${highestSeverity} severity risks remain; proceed only with mitigation and additional validation.`;
  }

  function getConfidenceLabel(lang, level) {
    if (lang === 'es') {
      if (level === 'high') {
        return 'Confianza alta';
      }
      if (level === 'medium') {
        return 'Confianza media';
      }
      return 'Confianza baja';
    }

    if (level === 'high') {
      return 'High confidence';
    }
    if (level === 'medium') {
      return 'Medium confidence';
    }
    return 'Low confidence';
  }

  function getLocalizedLabel(dictionary, group, key) {
    const labels = dictionary.executiveReport.metrics.labels;
    if (group === 'severity') {
      return labels[key] || key;
    }
    if (group === 'result') {
      return labels[key] || key;
    }
    if (group === 'publish') {
      return labels[key] || key;
    }
    return key;
  }

  function getLocalizedPublishLabel(dictionary, publishKey) {
    return dictionary.executiveReport.metrics.labels[publishKey] || publishKey;
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function normalizeDemoReportItem(report, index) {
    const normalized = report || {};
    const tester = String(normalized.userId || normalized.email || `tester_${index + 1}`);
    const email = String(normalized.email || '').trim();
    const screenName = String(normalized.screenName || 'N/A').trim() || 'N/A';
    const severityKey = getSeverityKey(normalized.severity);
    const resultKey = getResultKey(normalized.result);
    const publishKey = getPublishKey(normalized.publishRecommendation);

    return {
      id: `report-item-${index + 1}`,
      tester,
      email,
      screenName,
      severityKey,
      resultKey,
      publishKey,
      feedbackText: String(normalized.feedbackText || '').trim(),
      stepsToReproduce: String(normalized.stepsToReproduce || '').trim(),
      suggestion: String(normalized.suggestion || '').trim(),
      uxDetails: String(normalized.uxDetails || '').trim(),
      markdownReport: String(normalized.markdownReport || '').trim(),
    };
  }

  function renderLiveReportExplorer() {
    const container = document.querySelector('[data-report-explorer-list]');
    if (!container) {
      return;
    }

    const dictionary = translations[currentLang] || translations.en;
    const copy = dictionary.executiveReport.liveReportExplorer;

    if (!Array.isArray(demoReportItems) || demoReportItems.length === 0) {
      container.innerHTML = `<article class="report-item"><p class="report-item__panel">${escapeHtml(copy.noReports)}</p></article>`;
      return;
    }

    container.innerHTML = demoReportItems.map((item) => {
      const severityText = getLocalizedLabel(dictionary, 'severity', item.severityKey);
      const resultText = getLocalizedLabel(dictionary, 'result', item.resultKey);
      const publishText = getLocalizedPublishLabel(dictionary, item.publishKey);

      const feedbackText = item.feedbackText || (currentLang === 'es'
        ? 'Sin detalle de feedback disponible.'
        : 'No feedback detail available.');
      const stepsText = item.stepsToReproduce || (currentLang === 'es'
        ? 'Sin pasos disponibles.'
        : 'No steps available.');
      const suggestionText = item.suggestion || (currentLang === 'es'
        ? 'Sin sugerencia disponible.'
        : 'No suggestion available.');

      const testerHeadline = item.email
        ? `${item.tester} (${item.email})`
        : item.tester;

      const uxLine = item.uxDetails
        ? `<p><strong>${escapeHtml(copy.labels.uxDetails)}:</strong> ${escapeHtml(item.uxDetails)}</p>`
        : '';

      const markdownLine = item.markdownReport
        ? `<p><strong>${escapeHtml(copy.labels.markdownPreview)}:</strong></p><pre><code>${escapeHtml(item.markdownReport)}</code></pre>`
        : '';

      return `
        <article class="report-item">
          <h4 class="report-item__header">
            <button class="report-item__trigger" type="button" data-report-item-trigger aria-expanded="false" aria-controls="${escapeHtml(item.id)}" aria-label="${escapeHtml(copy.expand)}">
              <strong>${escapeHtml(copy.labels.tester)}:</strong> ${escapeHtml(testerHeadline)}
              <div class="report-item__meta">
                <span><strong>${escapeHtml(copy.labels.screen)}:</strong> ${escapeHtml(item.screenName)}</span>
                <span><strong>${escapeHtml(copy.labels.severity)}:</strong> ${escapeHtml(severityText)}</span>
                <span><strong>${escapeHtml(copy.labels.result)}:</strong> ${escapeHtml(resultText)}</span>
                <span><strong>${escapeHtml(copy.labels.publishRecommendation)}:</strong> ${escapeHtml(publishText)}</span>
              </div>
            </button>
          </h4>
          <div class="report-item__panel" id="${escapeHtml(item.id)}" hidden>
            <p><strong>${escapeHtml(copy.labels.publishRecommendation)}:</strong> ${escapeHtml(publishText)}</p>
            <p><strong>${escapeHtml(copy.labels.feedback)}:</strong> ${escapeHtml(feedbackText)}</p>
            <p><strong>${escapeHtml(copy.labels.steps)}:</strong> ${escapeHtml(stepsText)}</p>
            <p><strong>${escapeHtml(copy.labels.suggestion)}:</strong> ${escapeHtml(suggestionText)}</p>
            ${uxLine}
            ${markdownLine}
          </div>
        </article>`;
    }).join('');
  }

  function setupLiveReportExplorer() {
    const container = document.querySelector('[data-report-explorer-list]');
    if (!container) {
      return;
    }

    container.addEventListener('click', (event) => {
      const trigger = event.target.closest('[data-report-item-trigger]');
      if (!trigger) {
        return;
      }

      const panelId = trigger.getAttribute('aria-controls');
      const panel = panelId ? document.getElementById(panelId) : null;
      if (!panel) {
        return;
      }

      const dictionary = translations[currentLang] || translations.en;
      const copy = dictionary.executiveReport.liveReportExplorer;
      const expanded = trigger.getAttribute('aria-expanded') === 'true';
      const nextExpanded = !expanded;
      trigger.setAttribute('aria-expanded', nextExpanded ? 'true' : 'false');
      trigger.setAttribute('aria-label', nextExpanded ? copy.collapse : copy.expand);
      panel.hidden = !nextExpanded;

      const stateText = nextExpanded ? dictionary.a11y.expanded : dictionary.a11y.collapsed;
      announceToScreenReader(`${copy.title} ${stateText}`);
    });
  }

  function renderDemoReport() {
    if (!demoReportStats) {
      return;
    }

    const dictionary = translations[currentLang] || translations.en;
    const stats = demoReportStats;
    const total = stats.totalReports;

    const decisionText = getDecisionText(currentLang, stats.releaseDecision);
    const highestSeverityLabel = getLocalizedLabel(dictionary, 'severity', stats.highestSeverity);
    const confidenceText = `${stats.confidence.overall}/100 (${getConfidenceLabel(currentLang, stats.confidence.level)})`;

    const statusText = demoReportSource === 'loaded'
      ? dictionary.executiveReport.demoStatus.loaded
      : dictionary.executiveReport.demoStatus.fallback;

    setText('[data-demo-status]', statusText);
    setText('[data-demo-release-decision]', decisionText);
    setText(
      '[data-demo-release-reason]',
      getDecisionReason(currentLang, stats.releaseDecision, highestSeverityLabel.toLowerCase()),
    );

    setText('[data-demo-score-overall]', confidenceText);
    setText(
      '[data-demo-score-stability]',
      `${currentLang === 'es' ? 'Estabilidad' : 'Stability'}: ${stats.confidence.stability}/100`,
    );
    setText(
      '[data-demo-score-usability]',
      `${currentLang === 'es' ? 'Usabilidad' : 'Usability'}: ${stats.confidence.usability}/100`,
    );
    setText(
      '[data-demo-score-readiness]',
      `${currentLang === 'es' ? 'Release readiness' : 'Release readiness'}: ${stats.confidence.readiness}/100`,
    );

    const topIssueSeverity = getLocalizedLabel(dictionary, 'severity', stats.topIssue.severity).toLowerCase();
    const topIssueResult = getLocalizedLabel(dictionary, 'result', stats.topIssue.result).toLowerCase();
    const topIssueFeedback = stats.topIssue.feedbackText || (currentLang === 'es'
      ? 'Sin detalle de feedback disponible.'
      : 'No feedback detail available.');
    setText(
      '[data-demo-top-issue]',
      `[${stats.topIssue.userId}] (${topIssueSeverity} / ${topIssueResult}) ${topIssueFeedback}`,
    );

    const screenName = stats.mostAffectedScreen;
    setText(
      '[data-demo-plan-short-1]',
      currentLang === 'es'
        ? `P1: Reducir severidad ${highestSeverityLabel.toLowerCase()} en flujo principal (${screenName}).`
        : `P1: Reduce ${highestSeverityLabel.toLowerCase()} severity in the main flow (${screenName}).`,
    );
    setText(
      '[data-demo-plan-short-2]',
      currentLang === 'es'
        ? 'P2: Estabilizar pantalla mas reportada con escenarios guiados.'
        : 'P2: Stabilize the most reported screen with guided scenarios.',
    );
    setText(
      '[data-demo-plan-short-3]',
      currentLang === 'es'
        ? 'P3: Mitigar impacto de uso con mejoras de UX y feedback de error.'
        : 'P3: Mitigate usage impact with UX and error-feedback improvements.',
    );
    setText(
      '[data-demo-plan-short-4]',
      currentLang === 'es'
        ? 'P4: Cerrar bloqueadores de release con responsables y ETA.'
        : 'P4: Close release blockers with owners and ETA.',
    );
    setText(
      '[data-demo-plan-short-5]',
      currentLang === 'es'
        ? 'P5: Resolver observaciones UX destacadas en estado de publicacion.'
        : 'P5: Resolve highlighted UX observations in publish flow state.',
    );

    setText('[data-demo-severity-critical]', String(stats.severity.critical));
    setText('[data-demo-severity-high]', String(stats.severity.high));
    setText('[data-demo-severity-medium]', String(stats.severity.medium));
    setText('[data-demo-severity-low]', String(stats.severity.low));
    setBar('[data-demo-bar-severity-critical]', stats.severity.critical, total);
    setBar('[data-demo-bar-severity-high]', stats.severity.high, total);
    setBar('[data-demo-bar-severity-medium]', stats.severity.medium, total);
    setBar('[data-demo-bar-severity-low]', stats.severity.low, total);

    setText('[data-demo-result-workedwell]', String(stats.result.workedWell));
    setText('[data-demo-result-worked]', String(stats.result.worked));
    setText('[data-demo-result-needsimprovements]', String(stats.result.needsImprovements));
    setText('[data-demo-result-didntwork]', String(stats.result.didntWork));
    setBar('[data-demo-bar-result-workedwell]', stats.result.workedWell, total);
    setBar('[data-demo-bar-result-worked]', stats.result.worked, total);
    setBar('[data-demo-bar-result-needsimprovements]', stats.result.needsImprovements, total);
    setBar('[data-demo-bar-result-didntwork]', stats.result.didntWork, total);

    setText('[data-demo-publish-yes]', String(stats.publish.yes));
    setText('[data-demo-publish-notyet]', String(stats.publish.notYet));
    setText('[data-demo-publish-no]', String(stats.publish.no));
    setBar('[data-demo-bar-publish-yes]', stats.publish.yes, total);
    setBar('[data-demo-bar-publish-notyet]', stats.publish.notYet, total);
    setBar('[data-demo-bar-publish-no]', stats.publish.no, total);

    const totalLabel = currentLang === 'es'
      ? `Total analizado: ${total} reportes`
      : `Total analyzed: ${total} reports`;
    setText('[data-i18n="executiveReport.metrics.severity.total"]', totalLabel);
    setText('[data-i18n="executiveReport.metrics.result.total"]', totalLabel);
    setText('[data-i18n="executiveReport.metrics.publish.total"]', totalLabel);

    setText('[data-demo-summary-total]', String(total));
    setText('[data-demo-summary-screen]', screenName);
    setText('[data-demo-summary-severity]', highestSeverityLabel);
    setText('[data-demo-summary-decision]', decisionText);
    setText('[data-demo-summary-score]', confidenceText);

    const promptLines = currentLang === 'es'
      ? [
          'Actua como un ingeniero senior corrigiendo una app Flutter basada en feedback beta real.',
          '',
          `Decision de publicacion: ${decisionText}`,
          `Beta Confidence Score: ${confidenceText}`,
          '',
          'Prioridades del plan 48h:',
          `- P1: Reducir severidad ${highestSeverityLabel.toLowerCase()} en ${screenName}.`,
          '- P2: Estabilizar pantalla mas reportada.',
          '- P3: Mitigar impacto de uso.',
          '- P4: Cerrar brechas de release.',
          '- P5: Resolver observaciones UX destacadas.',
          '',
          'Restricciones obligatorias:',
          '- No hacer refactor general.',
          '- Corregir por orden de prioridad 48h.',
          '- Mantener compatibilidad hacia atras.',
          '- Ejecutar analyze y tests al final.',
        ]
      : [
          'Act as a senior engineer fixing a Flutter app using real beta feedback.',
          '',
          `Release Decision: ${decisionText}`,
          `Beta Confidence Score: ${confidenceText}`,
          '',
          '48h plan priorities:',
          `- P1: Reduce ${highestSeverityLabel.toLowerCase()} severity in ${screenName}.`,
          '- P2: Stabilize the most reported screen.',
          '- P3: Mitigate usage impact.',
          '- P4: Close release decision gaps.',
          '- P5: Address highlighted UX observations.',
          '',
          'Mandatory constraints:',
          '- Do not do a general refactor.',
          '- Fix by 48h priority order.',
          '- Keep backwards compatibility.',
          '- Run analyze and tests at the end.',
        ];
    setText('[data-demo-prompt-text]', promptLines.join('\n'));
  }

  async function loadDemoReport() {
    try {
      const response = await fetch('demo/beta_reports.json', { cache: 'no-store' });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const reports = await response.json();
      demoReportStats = computeDemoStats(reports);
      demoReportItems = Array.isArray(reports)
        ? reports.map((report, index) => normalizeDemoReportItem(report, index))
        : [];
      demoReportSource = 'loaded';
    } catch (_) {
      demoReportStats = { ...fallbackDemoStats };
      demoReportItems = fallbackDemoReports.map((report, index) => (
        normalizeDemoReportItem(report, index)
      ));
      demoReportSource = 'fallback';
    }

    renderDemoReport();
    renderLiveReportExplorer();
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
    renderDemoReport();
    renderLiveReportExplorer();

    localStorage.setItem(STORAGE_KEY, lang);
  }

  function getShareDictionary() {
    return translations[currentLang] || translations.en;
  }

  function announceToScreenReader(message) {
    const region = document.getElementById('a11y-live-region');
    if (!region || !message) {
      return;
    }

    region.textContent = '';
    window.setTimeout(() => {
      region.textContent = message;
    }, 30);
  }

  function updateTopNavCurrentLink() {
    const links = Array.from(document.querySelectorAll('.top-nav__link[href^="#"]'));
    if (links.length === 0) {
      return;
    }

    const activeHash = window.location.hash || '#top';
    links.forEach((link) => {
      const isActive = link.getAttribute('href') === activeHash;
      if (isActive) {
        link.setAttribute('aria-current', 'page');
      } else {
        link.removeAttribute('aria-current');
      }
    });
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

    announceToScreenReader(text);
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
        const nextExpanded = !isExpanded;
        setFaqState(button, nextExpanded);

        const dictionary = translations[currentLang] || translations.en;
        const stateText = nextExpanded ? dictionary.a11y.expanded : dictionary.a11y.collapsed;
        announceToScreenReader(`${button.textContent.trim()} ${stateText}`);
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
        const nextExpanded = !isExpanded;
        setActionPlanState(button, nextExpanded);

        const dictionary = translations[currentLang] || translations.en;
        const stateText = nextExpanded ? dictionary.a11y.expanded : dictionary.a11y.collapsed;
        announceToScreenReader(`${button.textContent.trim()} ${stateText}`);
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

      const dictionary = translations[currentLang] || translations.en;
      const stateText = nextExpanded ? dictionary.a11y.expanded : dictionary.a11y.collapsed;
      announceToScreenReader(`${dictionary.executiveReport.promptViewer.title} ${stateText}`);
    });

    copyButton.addEventListener('click', async () => {
      const dictionary = translations[currentLang] || translations.en;
      const copied = await copyToClipboard(promptCode.textContent || '');
      if (!copied) {
        return;
      }

      copyButton.textContent = dictionary.executiveReport.promptViewer.copied;
      copyButton.classList.add('is-success');
      announceToScreenReader(dictionary.executiveReport.promptViewer.copied);
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

  function setupIntegrationGuideCopy() {
    const buttons = Array.from(document.querySelectorAll('[data-copy-integration-code]'));
    if (buttons.length === 0) {
      return;
    }

    buttons.forEach((button) => {
      button.addEventListener('click', async () => {
        const code = button.parentElement
          ? button.parentElement.querySelector('[data-integration-code]')
          : null;
        if (!code) {
          return;
        }

        const copied = await copyToClipboard(code.textContent || '');
        if (!copied) {
          return;
        }

        const dictionary = translations[currentLang] || translations.en;
        button.textContent = dictionary.integrationGuide.copied;
        button.classList.add('is-success');
        announceToScreenReader(dictionary.integrationGuide.copied);

        window.setTimeout(() => {
          const fallbackDictionary = translations[currentLang] || translations.en;
          button.textContent = fallbackDictionary.integrationGuide.copyButton;
          button.classList.remove('is-success');
        }, 1400);
      });
    });
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

  window.addEventListener('hashchange', updateTopNavCurrentLink);

  setupFaqAccordion();
  setupActionPlanAccordion();
  setupAiPromptViewer();
  setupIntegrationGuideCopy();
  setupLiveReportExplorer();
  updateTopNavCurrentLink();
  loadDemoReport();
})();
