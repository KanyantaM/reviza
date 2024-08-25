from rest_framework import generics
from .models import StudyMaterial, University, Student
from .serializers import *
from .filters import StudyMaterialFilter
from django_filters import rest_framework as filters

class SingleStudentView(generics.RetrieveUpdateAPIView, generics.DestroyAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class StudentsView(generics.ListCreateAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class StudyMaterialsView(generics.ListCreateAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer
    filter_backends = (filters.DjangoFilterBackend,)
    filterset_class = StudyMaterialFilter

class SingleStudyMaterialView(generics.RetrieveUpdateAPIView, generics.DestroyAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer

class UniversityView(generics.ListAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer 