from rest_framework import generics
from .models import StudyMaterial
from .serializers import StudyMaterialSerializer

class StudyMaterialsView(generics.ListCreateAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer

class SingleStudyMaterialView(generics.RetrieveUpdateAPIView, generics.DestroyAPIView):
    queryset = StudyMaterial.objects.all()
    serializer_class = StudyMaterialSerializer 