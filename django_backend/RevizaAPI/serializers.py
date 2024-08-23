from rest_framework import serializers
from .models import *

class StudyMaterialSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudyMaterial
        fields = ['id', 'type', 'course', 'title', 'description', 'file', 'size', 'uploaded_at']

class CourseSerializer(serializers.ModelSerializer):
    materials = StudyMaterialSerializer(many=True, read_only=True)

    class Meta:
        model = Course
        fields = ['year', 'course']

class YearSerializer(serializers.ModelSerializer):
    course = CourseSerializer(many=True, read_only=True)

    class Meta:
        model = Year
        fields = ['year_number', 'course']

class ProgramSerializer(serializers.ModelSerializer):
    years = YearSerializer(many=True, read_only=True)

    class Meta:
        model = Program
        fields = ['name', 'years']

class FacultySerializer(serializers.ModelSerializer):
    programs = ProgramSerializer(many=True, read_only=True)

    class Meta:
        model = Faculty
        fields = ['name', 'programs']

class UniversitySerializer(serializers.ModelSerializer):
    faculties = FacultySerializer(many=True, read_only=True)

    class Meta:
        model = University
        fields = ['name', 'faculties']
