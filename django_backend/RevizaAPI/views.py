from rest_framework import generics, viewsets
from .models import StudyMaterial, University
from .serializers import StudyMaterialSerializer, UniversitySerializer

class StudyMaterialsView(generics.ListCreateAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer

class SingleStudyMaterialView(generics.RetrieveUpdateAPIView, generics.DestroyAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer

class UniversityView(generics.ListAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer 