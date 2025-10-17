from django.http import HttpResponse

def home(request):
    return HttpResponse("¡Bienvenido al proyecto Blue Demo! Actualizado con éxito.")