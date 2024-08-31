from django.contrib import admin
from .models import *

# class StudyMaterialInline(admin.TabularInline):
#     model = StudyMaterial
#     extra = 1

# class CourseInline(admin.TabularInline):
#     model = Course
#     extra = 1
#     inlines = [StudyMaterialInline]

# class YearInline(admin.TabularInline):
#     model = Year
#     extra = 1
#     inlines = [CourseInline]

# class ProgramAdmin(admin.TabularInline):
#     inlines = [YearInline]
#     list_display = ['name', 'faculty']
#     search_fields = ['name']

# class FacultyAdmin(admin.ModelAdmin):
#     inlines = [ProgramAdmin]
#     list_display = ['name', 'university']
#     search_fields = ['name']

# class UniversityAdmin(admin.ModelAdmin):
#     list_display = ['name']
#     search_fields = ['name']

# Register the models with the admin site
# admin.site.register(University, UniversityAdmin)
# admin.site.register(Faculty, FacultyAdmin)
# admin.site.register(Program, ProgramAdmin)
# admin.site.register(Year)
# admin.site.register(StudyMaterial)

admin.site.register(University)
admin.site.register(Faculty)
admin.site.register(Program)
admin.site.register(Year)
admin.site.register(Course)
admin.site.register(StudyMaterial)
admin.site.register(Student)