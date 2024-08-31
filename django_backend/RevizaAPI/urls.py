from django.urls import path
from . import views

urlpatterns = [
    path('studyMaterials/', views.StudyMaterialsView.as_view()),
    path('universities/', views.UniversityView.as_view()),
    path('studyMaterials/<str:pk>', views.SingleStudyMaterialView.as_view()),
    path('users/<str:pk>', views.SingleStudentView.as_view()),
    # path('studymaterials/upload/', views.StudyMaterialUploadView.as_view(), name='upload_study_material'),
    # path('studymaterials/<str:pk>/action/', views.StudyMaterialActionView.as_view(), name='study_material_action'),
    path('users/', views.StudentsView.as_view(),)
]
