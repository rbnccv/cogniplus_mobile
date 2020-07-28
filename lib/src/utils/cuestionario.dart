final List<Map<String, dynamic>> grupos = [
  {
    'id': 1,
    'completado': false,
    'videos': [
      {
        'id': 1,
        'titulo': 'clip 1',
        'descripcion': 'descripción del clip 1',
        'visualizaciones': 0
      }
    ]
  },
  {
    'id': 2,
    'completado': 0,
    'videos': [
      {
        'id': 2,
        'titulo': 'clip 2',
        'descripcion': 'descripción del clip 2',
        'visualizaciones': 0
      },
      {
        'id': 3,
        'titulo': 'clip 3',
        'descripcion': 'descripción del clip 3',
        'visualizaciones': 0
      }
    ]
  },
  {
    'id': 3,
    'completado': 0,
    'videos': [
      {
        'id': 4,
        'titulo': 'clip 4',
        'descripcion': 'descripción del clip 4',
        'visualizaciones': 0
      },
      {
        'id': 5,
        'titulo': 'clip 5',
        'descripcion': 'descripción del clip 5',
        'visualizaciones': 0
      },
      {
        'id': 6,
        'titulo': 'clip 6',
        'descripcion': 'descripción del clip 6',
        'visualizaciones': 0
      }
    ]
  },
  {
    'id': 4,
    'completado': 0,
    'videos': [
      {
        'id': 7,
        'titulo': 'clip 7',
        'descripcion': 'descripción del clip 7',
        'visualizaciones': 0
      },
      {
        'id': 8,
        'titulo': 'clip 8',
        'descripcion': 'descripción del clip 8',
        'visualizaciones': 0
      },
      {
        'id': 9,
        'titulo': 'clip 9',
        'descripcion': 'descripción del clip 9',
        'visualizaciones': 0
      },
      {
        'id': 10,
        'titulo': 'clip 10',
        'descripcion': 'descripción del clip 10',
        'visualizaciones': 0
      }
    ]
  }
];

final List<Map<String, dynamic>> questions = [
  {
    'id': 1,
    'video_id': 1,
    'pregunta': '¿De que color era la blusa de la mujer del video?',
    'respuestas': [
      {'id': 'b', 'opcion': 'azul'}
    ],
    'opciones': [
      {'id': 'a', 'opcion': 'azul'},
      {'id': 'b', 'opcion': 'violeta'},
      {'id': 'c', 'opcion': 'verde'},
    ]
  },
  {
    'id': 2,
    'video_id': 1,
    'pregunta': '¿Pregunta 2?',
    'respuestas': [
      {'id': 'a', 'opcion': 'opcion a'}
    ],
    'opciones': [
      {'id': 'a', 'opcion': 'opcion 1'},
      {'id': 'b', 'opcion': 'opcion 2'},
      {'id': 'c', 'opcion': 'opcion 3'},
    ]
  },
  {
    'id': 3,
    'video_id': 1,
    'pregunta': '¿Pregunta 3?',
    'respuestas': [
      {'id': 'c', 'opcion': 'opcion c'}
    ],
    'opciones': [
      {'id': 'a', 'opcion': 'opcion 1'},
      {'id': 'b', 'opcion': 'opcion 2'},
      {'id': 'c', 'opcion': 'opcion 3'},
    ]
  },
];
