from django.urls import path
from . import views

urlpatterns = [
    path('studyMaterials/', views.StudyMaterialsView.as_view())
]
