abstract class AbstractChipModel {
  /// Sets category selection to null (effectively setting it to "All").
  void clearCategorySelection();

  int? categorySelection;
  int localSelection = 1;

  void setCategorySelection(index);

  void setLocalSelection(index);
}
