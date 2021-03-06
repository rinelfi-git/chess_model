/**
* Name: ChessModel
* Based on the internal skeleton template. 
* Author: Rinelfi
* Tags: 
*/
model chess_model

import 'externals/plan.gaml'
import 'pieces/white_rook.gaml'
import 'pieces/black_rook.gaml'
import 'pieces/white_knight.gaml'
import 'pieces/black_knight.gaml'
import 'pieces/white_bishop.gaml'
import 'pieces/black_bishop.gaml'
import 'pieces/black_king.gaml'
import 'pieces/white_king.gaml'
import 'pieces/black_queen.gaml'
import 'pieces/white_queen.gaml'
import 'pieces/black_pawn.gaml'
import 'pieces/white_pawn.gaml'

global {
	rgb light_cell_color;
	rgb dark_cell_color;
	rgb target_cell_color;
	rgb road_cell_color;

	init {
		create WhiteRook number: 2;
		create BlackRook number: 2;
		create WhiteKnight number: 2;
		create BlackKnight number: 2;
		create WhiteBishop number: 2;
		create BlackBishop number: 2;
		create BlackKing number: 1;
		create WhiteKing number: 1;
		create BlackQueen number: 1;
		create WhiteQueen number: 1;
		create BlackPawn number: 8;
		create WhitePawn number: 8;

		// relocate rooks
		ask WhiteRook[0] {
			do move_to cell: Plan grid_at {0, 7};
		}

		ask WhiteRook[1] {
			do move_to cell: Plan grid_at {7, 7};
		}

		ask BlackRook[0] {
			do move_to cell: Plan grid_at {0, 0};
		}

		ask BlackRook[1] {
			do move_to cell: Plan grid_at {7, 0};
		}

		// relocate knights
		ask WhiteKnight[0] {
			do move_to cell: Plan grid_at {1, 7};
		}

		ask WhiteKnight[1] {
			do move_to cell: Plan grid_at {6, 7};
		}

		ask BlackKnight[0] {
			do move_to cell: Plan grid_at {1, 0};
		}

		ask BlackKnight[1] {
			do move_to cell: Plan grid_at {6, 0};
		}

		// relocate bishops
		ask WhiteBishop[0] {
			do move_to cell: Plan grid_at {2, 7};
		}

		ask WhiteBishop[1] {
			do move_to cell: Plan grid_at {5, 7};
		}

		ask BlackBishop[0] {
			do move_to cell: Plan grid_at {2, 0};
		}

		ask BlackBishop[1] {
			do move_to cell: Plan grid_at {5, 0};
		}

		// relocate kings
		ask WhiteKing {
			do move_to cell: Plan grid_at {3, 7};
		}

		ask BlackKing {
			do move_to cell: Plan grid_at {4, 0};
		}

		// relocate queens
		ask WhiteQueen {
			do move_to cell: Plan grid_at {4, 7};
		}

		ask BlackQueen {
			do move_to cell: Plan grid_at {3, 0};
		}
		
		loop i from: 0 to: 7 {
			ask BlackPawn[i] {
				do move_to cell: Plan grid_at {i, 1};
				is_first_movement <- true;
			}
			
			ask WhitePawn[i] {
				do move_to cell: Plan grid_at {i, 6};
				is_first_movement <- true;
			}
		}
	}

	action handle_mouse_event {
		list<Plan> selected_roads <- Plan where (each.status > 0 and each overlaps #user_location);
		write 'selected roads' +  selected_roads;
		if (length(selected_roads) > 0) {
			ask agents of_generic_species Piece where(each.is_clicked) {
				ask selected_roads {
					ask myself {
						do move_to cell: myself;
					}
				}
			}
		} else {
			ask agents of_generic_species Piece {
				is_clicked <- false;
			}
			list<Piece> selected_pieces <- agents of_generic_species Piece where (each.current_cell overlaps #user_location);
			ask Plan {
				status <- 0;
				do repaint;
			}

			ask selected_pieces {
				do compute_movement;
			}

		}

	}

}

experiment chess_model type: gui {
/** Insert here the definition of the input and output of the model */
	parameter 'Case claire' var: light_cell_color <- rgb(255, 206, 158) category: 'Couleurs';
	parameter 'Case fonc??' var: dark_cell_color <- rgb(209, 139, 71) category: 'Couleurs';
	parameter 'Case d\'??limination' var: target_cell_color <- #red category: 'Couleurs';
	parameter 'Case s??lectionn??e' var: road_cell_color <- #yellow category: 'Couleurs';
	output {
		display monde type: java2D {
			grid Plan border: #black;
			species WhiteRook aspect: default_aspect;
			species BlackRook aspect: default_aspect;
			species WhiteKnight aspect: default_aspect;
			species BlackKnight aspect: default_aspect;
			species WhiteBishop aspect: default_aspect;
			species BlackBishop aspect: default_aspect;
			species WhiteKing aspect: default_aspect;
			species BlackKing aspect: default_aspect;
			species WhiteQueen aspect: default_aspect;
			species BlackQueen aspect: default_aspect;
			species WhitePawn aspect: default_aspect;
			species BlackPawn aspect: default_aspect;
			event mouse_down action: handle_mouse_event;
		}

	}

}
