from django.urls import path
from . import views

urlpatterns = [
    path('studyMaterials/', views.StudyMaterialsView.as_view()),
    path('universities/', views.UniversityView.as_view()),
    path('studyMaterials/<str:pk>', views.SingleStudyMaterialView.as_view())
]
