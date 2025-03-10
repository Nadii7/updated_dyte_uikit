import '../../../dyte_uikit.dart';

abstract class DyteLivestreamState {}

class OnLivestreamInitial extends DyteLivestreamState {}

class OnLivestreamStarting extends DyteLivestreamState {}

class OnLivestreamStarted extends DyteLivestreamState {}

class OnLivestreamEnding extends DyteLivestreamState {}

class OnLivestreamEnded extends DyteLivestreamState {}

class OnLivestreamErrored extends DyteLivestreamState {}

class OnLivestreamStateUpdate extends DyteLivestreamState {
  final DyteLivestreamData data;
  OnLivestreamStateUpdate(this.data);
}

class OnLvsStageCountUpdate extends DyteLivestreamState {
  final int count;
  OnLvsStageCountUpdate(this.count);
}

class OnLvsViewerCountUpdated extends DyteLivestreamState {}

