from django.urls import path
from . import views

urlpatterns = [
    # path('studyMaterials/', views.studyMaterial)
    path('studyMateriels/', views.StudyMaterials.as_view())
]
