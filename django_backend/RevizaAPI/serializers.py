from rest_framework import serializers
from .models import *

class StudyMaterialSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudyMaterial
        fields = ['id', 'type', 'course_name', 'title', 'description', 'file', 'size', 'uploaded_at', 'fans', 'haters', 'reports']

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = ['name']

class YearSerializer(serializers.ModelSerializer):
    courses = CourseSerializer(many=True, read_only=True)

    class Meta:
        model = Year
        fields = ['year_number', 'courses']

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