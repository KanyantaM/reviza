from rest_framework import generics, viewsets
from .models import StudyMaterial, University
from .serializers import StudyMaterialSerializer, UniversitySerializer
from .filters import StudyMaterialFilter
from django_filters import rest_framework as filters

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