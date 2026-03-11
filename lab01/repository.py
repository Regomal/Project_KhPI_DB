from models import Supplier

class SupplierRepository:
    def __init__(self):
        self._suppliers: list[Supplier] = []
        self._current_id = 0


    def create(self, sup : Supplier):
        self._current_id += 1
        sup.id = self._current_id
        self._suppliers.append(sup)
        return sup.id



    def update(self, sup_id: int, **kwargs):
        for sup in self._suppliers:
            if sup.id == sup_id:
                for key, value in kwargs.items():
                    if hasattr(sup, key):   setattr(sup, key, value)
                return True
        return False

    def get_all(self, page: int = 1, size: int = 3):
        start = (page - 1) * size
        end = start + size
        return self._suppliers[start : end]


    def delete(self, sup_id: int):
        l = len(self._suppliers)
        self._suppliers = [s for s in self._suppliers if s.id != sup_id]
        return len(self._suppliers) < l