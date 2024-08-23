from django.urls import path
from . import views

urlpatterns = [
    # path('studyMaterials/', views.studyMaterial)
    path('studyMaterials/', views.StudyMaterials.as_view())
]
