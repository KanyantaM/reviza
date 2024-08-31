from django_filters import rest_framework as filters
from .models import StudyMaterial, Course

class StudyMaterialFilter(filters.FilterSet):
    course = filters.CharFilter(field_name='course__name', lookup_expr='icontains')
    type = filters.ChoiceFilter(field_name='type', choices=StudyMaterial.MaterialType.choices)

    class Meta:
        model = StudyMaterial
        fields = ['course', 'type']