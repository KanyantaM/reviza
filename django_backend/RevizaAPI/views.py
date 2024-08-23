from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.views import APIView

# Create your views here.

@api_view(['POST', 'GET'])
def studyMaterial(request):
    return Response('List of the study materials', status = status.HTTP_200_OK)

class StudyMaterials(APIView):
    def get(self, request):
        return Response({"message": "List of the books"}, status.HTTP_200_OK)
    def post(self, request):
        return Response({"message": "New book created"}, status.HTTP_201_CREATED)