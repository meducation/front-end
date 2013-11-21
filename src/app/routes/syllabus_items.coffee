exports.getSyllabusItems = (request, response) ->
  response.render 'syllabus_items.html'

exports.query = (request, response) ->
  response.json [
    {
      "id": 1,
      "name": "Medicine",
      "children": [
        {"id": 26329, "name": "Anaesthetics"},
        {"id": 27442, "name": "Breast"},
        {"id": 27792, "name": "Cardiology"},
        {"id": 29305, "name": "Dermatology"},
        {"id": 30033, "name": "Emergency Medicine"},
        {"id": 30098, "name": "Endocrinology"},
        {"id": 31117, "name": "Gastroenterology"},
        {"id": 34651, "name": "Neurology"},
        {"id": 35530, "name": "Paediatrics"},
        {"id": 36679, "name": "Psychiatry"},
        {"id": 36969, "name": "Radiology"},
        {"id": 37303, "name": "Rheumatology"},
        {"id": 60227, "name": "General Practice"},
        {"id": 91314, "name": "Infectious Diseases"},
        {"id": 101020, "name": "Respiratory Medicine"},
        {"id": 111216, "name": "Haematology"},
        {"id": 111217, "name": "Oncology and palliative care"},
        {"id": 111218, "name": "Ophthalmology"},
        {"id": 111219, "name": "Renal Medicine"}
      ]
    },
    {
      "id": 2,
      "name": "Specialties, Surgical",
      "children": [
        {"id": 27442, "name": "Breast"},
        {"id": 31509, "name": "Gynaecology"},
        {"id": 34955, "name": "Obstetrics"},
        {"id": 35155, "name": "Orthopaedics and Trauma"},
        {"id": 38540, "name": "General surgery"},
        {"id": 38555, "name": "Plastic surgery"},
        {"id": 38921, "name": "Cardiothoracic surgery"},
        {"id": 39580, "name": "Urology"},
        {"id": 111218, "name": "Ophthalmology"},
        {"id": 111252, "name": "Ear nose and throat (ENT)"},
        {"id": 111253, "name": "Maxillofacial"},
        {"id": 111254, "name": "Vascular surgery"},
        {"id": 111255, "name": "Paediatric Surgery"}
      ]
    },
    {
      "id": 3,
      "name": "Basic Sciences",
      "children": [
        {"id": 26268, "name": "Anatomy"},
        {"id": 27180, "name": "Biochemistry"},
        {"id": 30024, "name": "Embryology"},
        {"id": 30202, "name": "Epidemiology"},
        {"id": 31968, "name": "Histology"},
        {"id": 35495, "name": "Pathology"},
        {"id": 35755, "name": "Pharmacology"},
        {"id": 35971, "name": "Physiology"},
        {"id": 38020, "name": "Sociology"},
        {"id": 44581, "name": "Statistics"},
        {"id": 111256, "name": "Immunology and Microbiology"},
        {"id": 111257, "name": "Ethics and Law"}
      ]
    }
  ]